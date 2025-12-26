# Radiohead Vault - Python Edition
# Architect: Md Zarif Azfar
import os
import secrets
import struct
import numpy as np
from PIL import Image
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def encrypt(data, password):
    salt = secrets.token_bytes(16)
    kdf = PBKDF2HMAC(hashes.SHA256(), 32, salt, 200000, default_backend())
    key = kdf.derive(password.encode())
    iv = secrets.token_bytes(12)
    encryptor = Cipher(algorithms.AES(key), modes.GCM(iv), default_backend()).encryptor()
    ct = encryptor.update(data) + encryptor.finalize()
    return salt + iv + encryptor.tag + ct

def hide(cover_path, secret_path, out_path, pw):
    with open(secret_path, 'rb') as f: data = f.read()
    payload = struct.pack('>I', len(encrypt(data, pw))) + encrypt(data, pw)
    
    img = Image.open(cover_path).convert('RGB')
    arr = np.array(img)
    flat = arr.flatten()
    
    if len(payload)*8 > len(flat): raise ValueError("Image too small")
    
    # Injection
    bits = np.unpackbits(np.frombuffer(payload, dtype=np.uint8))
    flat[:len(bits)] = (flat[:len(bits)] & 0xFE) | bits
    
    # Noise Fill
    noise_len = len(flat) - len(bits)
    if noise_len > 0:
        noise = np.random.randint(0, 2, noise_len, dtype=np.uint8)
        flat[len(bits):] = (flat[len(bits):] & 0xFE) | noise
        
    Image.fromarray(flat.reshape(arr.shape)).save(out_path)
    print(f"Saved to {out_path}")

if __name__ == "__main__":
    print("Radiohead Vault (Python)")
    # Example usage
    # hide("cover.png", "secret.txt", "vault.png", "password")
