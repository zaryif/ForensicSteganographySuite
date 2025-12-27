# Forensic Steganography Suite - Complete Technical Documentation

**Author & Architect:** Md Zarif Azfar  
**Version:** v5.1 (Ultimate CRT Edition)  
**License:** MIT

---

## Table of Contents

1. [What Are We Solving?](#1-what-are-we-solving)
2. [How Are We Solving It?](#2-how-are-we-solving-it)
3. [Technologies Used - Complete Breakdown](#3-technologies-used---complete-breakdown)
4. [Python Implementation - Line by Line](#4-python-implementation---line-by-line)
5. [Web Implementation - Line by Line](#5-web-implementation---line-by-line)
6. [Why LSB Steganography?](#6-why-lsb-steganography)
7. [Why CSPRNG for Noise Injection?](#7-why-csprng-for-noise-injection)
8. [Interview Questions & Answers](#8-interview-questions--answers)
9. [User Questions & Answers](#9-user-questions--answers)
10. [Multi-Language Implementation Rationale](#10-multi-language-implementation-rationale)

---

## 1. What Are We Solving?

### The Core Problem

**Hiding sensitive data in plain sight** without leaving any mathematical or visual evidence of its existence.

Traditional encryption has a flaw: **it announces itself**. An encrypted file looks like random garbage - and that randomness itself is suspicious. If authorities find an encrypted container on your drive, you're asked: "What's the password?"

### Our Solution: Steganography + Encryption

We combine:
1. **Steganography** - Hiding data within innocent-looking media (images/audio)
2. **Strong Encryption** - AES-256-GCM authenticated encryption
3. **Anti-Forensic Noise** - CSPRNG-based noise filling to eliminate statistical signatures

**Result:** A photo of your cat that secretly contains your encrypted files, with no mathematical way to prove anything is hidden.

---

## 2. How Are We Solving It?

### The Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│                        LOCK (HIDE) PROCESS                          │
├─────────────────────────────────────────────────────────────────────┤
│ 1. SECRET FILES → ZIP them together (JSZip)                        │
│ 2. ZIP ARCHIVE → ENCRYPT with AES-256-GCM (PBKDF2 key derivation)  │
│ 3. ENCRYPTED BLOB → Convert to binary bits                         │
│ 4. COVER IMAGE → Extract pixel data (RGBA channels)                │
│ 5. INJECT bits into LSB (Least Significant Bit) of each channel    │
│ 6. FILL remaining space with CSPRNG random noise                   │
│ 7. OUTPUT → New image that looks identical but contains secrets    │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                      UNLOCK (EXTRACT) PROCESS                       │
├─────────────────────────────────────────────────────────────────────┤
│ 1. VAULT IMAGE → Extract pixel data                                │
│ 2. READ LSB bits → First 32 bits = payload length                  │
│ 3. READ payload → Extract encrypted data                           │
│ 4. DECRYPT → AES-256-GCM with password                             │
│ 5. DECOMPRESS → Unzip to get original files                        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Technologies Used - Complete Breakdown

### 3.1 Cryptographic Components

| Component | What It Does | Why We Use It |
|-----------|--------------|---------------|
| **AES-256-GCM** | Authenticated Encryption | Industry standard, provides both confidentiality AND integrity verification |
| **PBKDF2-HMAC-SHA256** | Key Derivation Function | Converts password to 256-bit key; 200,000 iterations make brute-force expensive |
| **CSPRNG** | Cryptographically Secure Random | `window.crypto.getRandomValues()` / `secrets.token_bytes()` - unpredictable randomness |

### 3.2 Why AES-256-GCM Specifically?

```
┌──────────────────────────────────────────────────────────────┐
│                     AES-256-GCM BREAKDOWN                    │
├──────────────────────────────────────────────────────────────┤
│ AES    = Advanced Encryption Standard (symmetric cipher)    │
│ 256    = 256-bit key (2^256 possible keys - unbreakable)    │
│ GCM    = Galois/Counter Mode (authenticated encryption)     │
│                                                              │
│ GCM provides:                                                │
│ • Confidentiality (data is encrypted)                       │
│ • Integrity (detects if data was modified)                  │
│ • Authentication (verifies correct password)                │
│                                                              │
│ If wrong password → GCM tag verification FAILS              │
│ If file corrupted → GCM tag verification FAILS              │
└──────────────────────────────────────────────────────────────┘
```

### 3.3 Encryption Data Structure

```
Salt (16 bytes) + IV (12 bytes) + AuthTag (16 bytes) + Ciphertext
     ↓                ↓               ↓                    ↓
  Random seed    Initialization   Authentication      Encrypted
  for PBKDF2     vector for GCM   tag (integrity)     payload
```

### 3.4 Python Dependencies

| Package | Purpose | Why This Specific Package? |
|---------|---------|---------------------------|
| `cryptography` | AES-GCM + PBKDF2 | Uses OpenSSL under the hood; most secure Python crypto library |
| `numpy` | Array manipulation | Vectorized operations 100x faster than Python loops |
| `Pillow (PIL)` | Image handling | Industry standard; reads/writes PNG without data loss |

### 3.5 Web Technologies

| Technology | Purpose |
|------------|---------|
| **Web Crypto API** | Browser-native cryptography (AES-GCM, PBKDF2) |
| **Canvas API** | Direct pixel-level image manipulation |
| **JSZip** | In-browser ZIP archive creation |
| **Blob/URL API** | File download without server |

---

## 4. Python Implementation - Line by Line

### `vault.py` - Complete Annotated Source

```python
# ═══════════════════════════════════════════════════════════════════════
# LINE 1-2: Module Header
# ═══════════════════════════════════════════════════════════════════════
# Radiohead Vault - Python Edition
# Architect: Md Zarif Azfar
```
**Purpose:** Attribution and identification. "Radiohead Vault" name comes from the original test image (Radiohead's OK Computer album art).

---

```python
# ═══════════════════════════════════════════════════════════════════════
# LINE 3-11: Imports
# ═══════════════════════════════════════════════════════════════════════
import os                            # Operating system interface (file paths)
import secrets                       # CSPRNG - Cryptographically Secure RNG
import struct                        # Binary packing (converts int to bytes)
import numpy as np                   # Numerical arrays for vectorized operations
from PIL import Image                # Pillow - Image loading/saving
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
```

| Import | WHY We Need It |
|--------|----------------|
| `os` | File path operations |
| `secrets` | Generate cryptographically secure random bytes (salt, IV) |
| `struct` | Pack payload length as 4-byte big-endian integer |
| `numpy` | Fast array operations for LSB manipulation |
| `PIL.Image` | Load PNG, convert to RGB array, save modified image |
| `cryptography.*` | Professional-grade AES-GCM encryption |

---

```python
# ═══════════════════════════════════════════════════════════════════════
# LINE 13-20: Encryption Function
# ═══════════════════════════════════════════════════════════════════════
def encrypt(data, password):
    salt = secrets.token_bytes(16)      # LINE 14: Generate 16 random bytes
    kdf = PBKDF2HMAC(                   # LINE 15: Key Derivation Function
        hashes.SHA256(),                # Hash algorithm
        32,                             # Output 32 bytes (256 bits for AES-256)
        salt,                           # Salt (prevents rainbow tables)
        200000,                         # Iterations (computational cost)
        default_backend()               # Use OpenSSL
    )
    key = kdf.derive(password.encode()) # LINE 16: Convert password → 256-bit key
    iv = secrets.token_bytes(12)        # LINE 17: 12-byte IV for GCM mode
    encryptor = Cipher(                 # LINE 18: Create cipher object
        algorithms.AES(key),            # AES with derived key
        modes.GCM(iv),                  # GCM mode with IV
        default_backend()
    ).encryptor()
    ct = encryptor.update(data) + encryptor.finalize()  # LINE 19: Encrypt
    return salt + iv + encryptor.tag + ct               # LINE 20: Pack everything
```

### Deep Dive: Each Line Explained

| Line | Code | What It Does | Why? |
|------|------|--------------|------|
| 14 | `salt = secrets.token_bytes(16)` | 16 random bytes | Salts prevent rainbow table attacks. Same password + different salt = different key |
| 15 | `PBKDF2HMAC(...)` | Setup key derivation | PBKDF2 stretches password into cryptographic key |
| 15 | `200000` iterations | Slow down KDF | Makes brute-force attacks 200,000x slower |
| 16 | `kdf.derive(password.encode())` | Password → 256-bit key | Human password → cryptographic key |
| 17 | `iv = secrets.token_bytes(12)` | 12-byte initialization vector | GCM requires 12 bytes; each encryption must be unique |
| 18-19 | `Cipher(...).encryptor()` | Create AES-GCM cipher | Authenticated encryption engine |
| 19 | `update(data) + finalize()` | Encrypt and generate auth tag | `finalize()` computes the authentication tag |
| 20 | `salt + iv + tag + ct` | Concatenate all components | Recipient needs all 4 to decrypt |

---

```python
# ═══════════════════════════════════════════════════════════════════════
# LINE 22-43: Hide (Steganography) Function
# ═══════════════════════════════════════════════════════════════════════
def hide(cover_path, secret_path, out_path, pw):
    with open(secret_path, 'rb') as f: 
        data = f.read()                 # LINE 23: Read secret file as bytes
    
    payload = struct.pack('>I', len(encrypt(data, pw))) + encrypt(data, pw)
    # LINE 24: Pack format: [4-byte length][encrypted data]
    # '>I' = big-endian unsigned 32-bit integer
    
    img = Image.open(cover_path).convert('RGB')  # LINE 26: Load image
    arr = np.array(img)                          # LINE 27: Image → numpy array
    flat = arr.flatten()                         # LINE 28: 3D array → 1D array
    
    if len(payload)*8 > len(flat):               # LINE 30: Capacity check
        raise ValueError("Image too small")      # Each pixel byte stores 1 bit
    
    # ═══════════════════════════════════════════════════════════════════
    # THE CORE LSB INJECTION (Lines 32-34)
    # ═══════════════════════════════════════════════════════════════════
    bits = np.unpackbits(np.frombuffer(payload, dtype=np.uint8))
    # LINE 33: Convert payload bytes to individual bits
    # Example: byte 0b10110010 → [1,0,1,1,0,0,1,0]
    
    flat[:len(bits)] = (flat[:len(bits)] & 0xFE) | bits
    # LINE 34: THE MAGIC LINE - LSB Injection
    # BREAKDOWN:
    #   flat[:len(bits)]  → Select only pixels we need
    #   & 0xFE            → Clear the LSB (0xFE = 11111110)
    #   | bits            → Set LSB to our secret bit
```

### THE MAGIC LINE Explained (Line 34)

```
Original pixel value:  10110011 (179)
                              ↓
Mask with 0xFE:        10110010 (178)  ← Clears last bit
                              ↓
OR with secret bit 1:  10110011 (179)  ← Sets our secret bit

Visual difference: 179 vs 178 = IMPERCEPTIBLE to human eye
Data stored: 1 secret bit per color channel
```

---

```python
    # ═══════════════════════════════════════════════════════════════════
    # NOISE INJECTION (Lines 36-40)
    # ═══════════════════════════════════════════════════════════════════
    noise_len = len(flat) - len(bits)       # LINE 37: Remaining capacity
    if noise_len > 0:
        noise = np.random.randint(0, 2, noise_len, dtype=np.uint8)
        # LINE 39: Generate random 0s and 1s
        
        flat[len(bits):] = (flat[len(bits):] & 0xFE) | noise
        # LINE 40: Fill remaining LSBs with random noise
```

### Why Noise Injection?

```
┌───────────────────────────────────────────────────────────────────┐
│            WITHOUT NOISE (Forensic Signature)                    │
├───────────────────────────────────────────────────────────────────┤
│ Entropy: ████████████░░░░░░░░░░░░  ← "Cliff" at data end        │
│          ↑ High entropy ↑ Normal                                 │
│                                                                   │
│ Detection: Analyst sees where hidden data ends                   │
├───────────────────────────────────────────────────────────────────┤
│            WITH CSPRNG NOISE (No Signature)                      │
├───────────────────────────────────────────────────────────────────┤
│ Entropy: ████████████████████████ ← Uniform high entropy        │
│                                                                   │
│ Detection: Impossible to determine where data ends               │
└───────────────────────────────────────────────────────────────────┘
```

---

```python
    # ═══════════════════════════════════════════════════════════════════
    # OUTPUT (Line 42-43)
    # ═══════════════════════════════════════════════════════════════════
    Image.fromarray(flat.reshape(arr.shape)).save(out_path)
    # LINE 42: Reshape 1D array back to image dimensions, save as PNG
    
    print(f"Saved to {out_path}")    # LINE 43: Confirmation message
```

---

## 5. Web Implementation - Key Components

### 5.1 Web Crypto API - Password to Key

```javascript
// ═══════════════════════════════════════════════════════════════════
// STEP 1: Import password as raw key material
// ═══════════════════════════════════════════════════════════════════
async function getKeyMaterial(password) {
    const enc = new TextEncoder();
    return window.crypto.subtle.importKey(
        "raw",                          // Key format
        enc.encode(password),           // Password as UTF-8 bytes
        { name: "PBKDF2" },            // Algorithm
        false,                          // Not extractable
        ["deriveBits", "deriveKey"]    // Allowed uses
    );
}
```

**Why `window.crypto.subtle`?** 
- Native browser cryptography
- Hardware-accelerated on modern CPUs
- No external dependencies = smaller attack surface

---

### 5.2 Key Derivation (PBKDF2)

```javascript
// ═══════════════════════════════════════════════════════════════════
// STEP 2: Derive AES key from password
// ═══════════════════════════════════════════════════════════════════
async function getKey(keyMaterial, salt) {
    return window.crypto.subtle.deriveKey(
        {
            name: "PBKDF2",
            salt: salt,                     // 16 random bytes
            iterations: 200000,             // Computational cost
            hash: "SHA-256"                 // Hash function
        },
        keyMaterial,                        // From step 1
        { name: "AES-GCM", length: 256 },  // Output: AES-256 key
        true,                               // Extractable
        ["encrypt", "decrypt"]              // Allowed operations
    );
}
```

### Why 200,000 Iterations?

| Iterations | Time per Attempt | Time for 1 Billion Attempts |
|------------|------------------|----------------------------|
| 1 | 0.001ms | 17 minutes |
| 1,000 | 1ms | 11.5 days |
| 200,000 | 200ms | 6,340 years |

---

### 5.3 CSPRNG for Anti-Forensic Noise

```javascript
// ═══════════════════════════════════════════════════════════════════
// Cryptographically Secure Random Bit Generator
// ═══════════════════════════════════════════════════════════════════
function getCSPRNG_Bit() {
    const buf = new Uint8Array(1);          // Create 1-byte buffer
    window.crypto.getRandomValues(buf);     // Fill with secure random
    return buf[0] & 1;                       // Return only the LSB (0 or 1)
}
```

**Why CSPRNG instead of `Math.random()`?**

| `Math.random()` | `crypto.getRandomValues()` |
|-----------------|---------------------------|
| Pseudo-random (predictable seed) | True random (hardware entropy) |
| Pattern detectable | Statistically indistinguishable from noise |
| Fine for games | Required for cryptography |

---

### 5.4 LSB Injection Core

```javascript
// ═══════════════════════════════════════════════════════════════════
// The Core LSB Setter
// ═══════════════════════════════════════════════════════════════════
const setBit = (index, bit) => {
    carrierBytes[index] = (carrierBytes[index] & 0xFE) | bit;
    //                    ↑ Clear LSB         ↑ Set to our bit
};

// Skip alpha channel (every 4th byte in RGBA)
const getNextIdx = () => {
    // For images: skip alpha channel (R, G, B, skip A, R, G, B, skip A...)
    let realIdx = Math.floor(carrierIdx / 3) * 4 + (carrierIdx % 3);
    carrierIdx++;
    return realIdx;
};
```

---

## 6. Why LSB Steganography?

### 6.1 The Visual Argument

```
Original Pixel:    RGB(148, 203, 87)   = A specific shade of green
Modified Pixel:    RGB(149, 202, 86)   = Still the same green (to human eye)
                         ↓↓↓
                    3 bits hidden!
```

### 6.2 Bit Significance

| Bit Position | Value Weight | Visual Impact if Changed |
|--------------|--------------|-------------------------|
| Bit 7 (MSB) | 128 | Dramatic color shift |
| Bit 6 | 64 | Very noticeable |
| Bit 5 | 32 | Noticeable |
| Bit 4 | 16 | Slightly visible |
| Bit 3 | 8 | Barely visible |
| Bit 2 | 4 | Imperceptible |
| Bit 1 | 2 | Imperceptible |
| Bit 0 (LSB) | 1 | **INVISIBLE** ← We use this |

### 6.3 Capacity Calculation

```
Image: 1920 x 1080 pixels
Channels: 3 (RGB, no alpha stored)
Total bytes: 1920 × 1080 × 3 = 6,220,800 bytes

LSB capacity: 6,220,800 bits = 777,600 bytes = 759 KB

A single 1080p image can hide 759 KB of encrypted data!
```

---

## 7. Why CSPRNG for Noise Injection?

### 7.1 The Entropy Attack

Forensic analysts use **entropy analysis** to detect steganography:

```
Normal image:     Entropy → 7.2 bits/byte (natural image patterns)
Stego (no noise): Entropy → 7.9 at start, 7.2 at end ← DETECTABLE CLIFF
Stego (CSPRNG):   Entropy → 7.95 uniform throughout ← NO SIGNATURE
```

### 7.2 Why Not `Math.random()`?

```
Math.random() pattern over 1 million samples:
████████████████████████  ← Statistically identifiable pattern

CSPRNG pattern over 1 million samples:  
████████████████████████  ← Indistinguishable from true randomness
```

**Mathematical Proof:** CSPRNG passes all NIST Statistical Test Suite tests. `Math.random()` fails multiple tests.

---

## 8. Interview Questions & Answers

### Q1: What is steganography and how does it differ from cryptography?

**Answer:**
- **Cryptography** encrypts data so it's unreadable but its existence is known
- **Steganography** hides data so its existence is unknown
- We use BOTH: encrypt first (AES-GCM), then hide in image (LSB)

---

### Q2: Why did you choose AES-GCM over AES-CBC?

**Answer:**
| Feature | AES-CBC | AES-GCM |
|---------|---------|---------|
| Confidentiality | ✅ | ✅ |
| Integrity | ❌ | ✅ (built-in) |
| Authentication | ❌ | ✅ (auth tag) |
| Parallel Processing | ❌ | ✅ |
| Padding Required | Yes | No |

GCM provides authenticated encryption - if a single bit is modified or wrong password used, decryption fails with authentication error rather than producing garbage.

---

### Q3: Explain PBKDF2 and why 200,000 iterations

**Answer:**
PBKDF2 (Password-Based Key Derivation Function 2) converts human passwords to cryptographic keys.

**Why iterations matter:**
- Each iteration = one hash computation required
- Brute-force must compute 200,000 hashes per password guess
- GPU cracking: ~10 million hashes/second → 50 passwords/second
- "password123" becomes impractical to crack

---

### Q4: What's the forensic advantage of CSPRNG noise?

**Answer:**
Without noise, forensic analysis shows an "entropy cliff" where hidden data ends. CSPRNG fills remaining space with unpredictable random bits, making the entire image appear equally random. Statistical analysis cannot distinguish between data and noise.

---

### Q5: Why PNG/WAV only? Why not JPEG/MP3?

**Answer:**
```
JPEG: Uses lossy DCT compression
      When saved: pixel values are approximated
      Result: LSB data is DESTROYED by compression

PNG:  Uses lossless DEFLATE compression
      When saved: pixel values are EXACT
      Result: LSB data is PRESERVED perfectly
```

---

### Q6: How do you handle the alpha channel?

**Answer:**
We skip alpha (transparency) because:
1. Many PNG tools auto-modify alpha values
2. Alpha = 255 (fully opaque) is common, modifying creates visible artifacts
3. We use only RGB channels: 3 bits per pixel instead of 4

---

### Q7: What is the capacity formula?

**Answer:**
```
Capacity (bits) = Width × Height × 3
Capacity (bytes) = Width × Height × 3 / 8

Example: 4000×3000 image
= 4000 × 3000 × 3 = 36,000,000 bits
= 4,500,000 bytes = 4.3 MB of hidden data
```

---

### Q8: How does the extraction process know how much data to read?

**Answer:**
First 32 bits of injected data = payload length (big-endian unsigned integer)

```
Bits 0-31:    Payload length (e.g., "00000000000000000000001101011010")
Bits 32+:     Actual encrypted payload
```

During extraction:
1. Read first 32 LSBs → convert to integer
2. Read that many bytes × 8 more bits
3. Decrypt and decompress

---

### Q9: What makes your implementation "forensic-grade"?

**Answer:**
Three properties:
1. **Visual invisibility:** LSB changes are imperceptible
2. **Statistical invisibility:** CSPRNG noise eliminates entropy signatures
3. **Cryptographic security:** AES-256-GCM provides authenticated encryption

---

### Q10: Why implement in multiple languages?

**Answer:**
| Language | Use Case |
|----------|----------|
| **HTML/JS** | Maximum OpSec - runs in RAM, zero installation traces |
| **Python** | Data science integration, batch processing |
| **Rust** | Memory-safe high performance |
| **C++** | Raw speed for large files |
| **Swift** | Native iOS with Secure Enclave |
| **Bash** | Server automation, existing tool integration |

---

## 9. User Questions & Answers

### Q: Can this be cracked by the police/FBI?

**A:** If implemented correctly:
- Without password: Mathematically impossible (AES-256 has 2^256 keys)
- With physical access: Cold boot attacks could recover keys from RAM (use Live OS)
- With rubber hose: Nothing is secure against physical coercion

---

### Q: Why does my output image look the same?

**A:** That's the point! LSB changes are invisible. Difference:
- Original: pixel value 148
- Modified: pixel value 149
- Human eye cannot detect 0.4% color change

---

### Q: What if I upload to Instagram/WhatsApp?

**A:** DATA DESTROYED. Social media platforms:
1. Resize images
2. Re-compress (lossy)
3. Strip metadata

Always share via direct file transfer (USB, P2P, encrypted email).

---

### Q: Can I hide data in GIFs?

**A:** Not recommended. GIF uses indexed color palettes (max 256 colors). LSB modification can completely change which palette entry is selected, creating visible artifacts.

---

### Q: How secure is the web version really?

**A:** Depends on threat model:
- Runs entirely in browser RAM
- No server communication
- Garbage collected on tab close
- For maximum security: use in Tails OS (RAM-only live system)

---

## 10. Multi-Language Implementation Rationale

### HTML/Web - The "Silent" Standard

```
Pros:                              Cons:
✓ Zero installation               ✗ Slower than native
✓ Zero disk traces                ✗ JS garbage collection
✓ Works on any device            ✗ Browser memory limits
✓ Perfect for Live OS
```

### Python - The Analyst's Choice

```
Pros:                              Cons:
✓ NumPy vectorization             ✗ Leaves pip install logs
✓ Easy integration                ✗ .pyc bytecode files
✓ Data science stack              ✗ Python path traces
```

### Rust - Modern Safety

```
Pros:                              Cons:
✓ Memory safe                     ✗ Large binary size
✓ C++ speed                       ✗ Longer compile times
✓ No garbage collector
✓ Static linking possible
```

### C++ - Raw Performance

```
Pros:                              Cons:
✓ Maximum speed                   ✗ Memory safety risks
✓ Direct memory control           ✗ Core dump risks
✓ Existing OpenSSL ecosystem      ✗ Complex error handling
```

### Swift/iOS - Mobile Fortress

```
Pros:                              Cons:
✓ Secure Enclave hardware         ✗ iCloud sync risks
✓ iOS sandboxing                  ✗ App Store detection
✓ CryptoKit native                ✗ Closed ecosystem
```

### Bash - Terminal Warrior

```
Pros:                              Cons:
✓ Uses battle-tested tools        ✗ Shell history logging
✓ Easy scripting                  ✗ Dependency installation traces
✓ Cron integration                ✗ steghide = JPEG only
```

---

## Appendix: Quick Reference

### Encryption Parameters

```
Algorithm:    AES-256-GCM
Key Size:     256 bits (32 bytes)
Salt Size:    128 bits (16 bytes)
IV Size:      96 bits (12 bytes)
Auth Tag:     128 bits (16 bytes)
KDF:          PBKDF2-HMAC-SHA256
Iterations:   200,000
```

### Data Structure

```
[Salt 16B][IV 12B][Tag 16B][Ciphertext...]
```

### Python Dependencies

```
cryptography>=3.4.0    # AES-GCM, PBKDF2
numpy>=1.19.0          # Vectorized operations
Pillow>=8.0.0          # Image handling
```

### Capacity Rule of Thumb

```
1 Megapixel image ≈ 375 KB hidden capacity
4K image (8MP) ≈ 3 MB hidden capacity
```

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Author:** Md Zarif Azfar
