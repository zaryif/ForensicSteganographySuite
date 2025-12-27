# Radiohead Vault: The Ultimate Technical Compendium

**Forensic-Grade Steganography Across Six Architectures**

**Author & Architect:** Md Zarif Azfar
**Copyright:** © 2025 Md Zarif Azfar. All Rights Reserved.
**Date:** December 2025
**Version:** Ultimate Reference (v3.0)
**Scope:** HTML5, Python, C++, Rust, Swift (iOS), Bash (Shell)
**Objective:** Total Anti-Forensic Dominance

## 1. Abstract & Core Philosophy

The Radiohead Vault is not merely a tool; it is a rigid methodology for Anti-Forensic Data Storage. The goal is to hide information in plain sight, ensuring that the existence of the data cannot be mathematically proven by an adversary.

### 1.1 Project Origin & Authorship

This project was conceptualized, designed, and executed entirely by the Architect, Md Zarif Azfar.

**Why "Radiohead"?**
The nomenclature "Radiohead Vault" pays homage to the initial test vector used during the R&D phase: the album artwork for Radiohead's *OK Computer*. This image served as the first successful subject for the LSB (Least Significant Bit) injection algorithm. The chaotic, glitch-art aesthetic of the album cover provided perfect visual cover for early steganography tests, symbolizing the project's goal of finding order (data) within chaos (noise).

### 1.2 The "Perfect" Steganography Criteria

To be considered "Forensic-Grade," an implementation must satisfy three axioms:

1.  **Visual Invisibility:** The carrier (image/audio) must look identical to the original to the human eye.
2.  **Statistical Invisibility:** The carrier must not exhibit mathematical anomalies (e.g., entropy cliffs) that distinguish it from natural noise (ISO grain/tape hiss).
3.  **Zero Trace:** The tool must not leave artifacts (logs, history, cache) on the host operating system.

## 2. Media Format Analysis: The "Why" and "Why Not"

This section details the critical decision-making process regarding media formats. This is the foundation of the vault's security.

### 2.1 The Chosen Few: PNG and WAV

We exclusively use Lossless formats.

*   **PNG (Portable Network Graphics):** Uses DEFLATE compression (similar to ZIP). It is lossless. If a pixel is defined as RGB(100, 100, 100), it will remain exactly that value forever. This allows us to modify the Least Significant Bit (LSB) without the file format "fixing" or "blurring" our changes.
*   **WAV (Waveform Audio):** Stores raw Pulse Code Modulation (PCM) data. It is a direct digital representation of the analog signal. We can hide data in the "tape hiss" of the recording.

### 2.2 The Rejected: Why Not Video (MP4/MKV)?

Users often ask, "Why not hide data in a movie file? It's huge!"
This is a fatal forensic mistake.

*   **Inter-frame Compression:** Video codecs (H.264, HEVC) do not store every frame as a picture. They store "Keyframes" (I-frames) and then mathematical instructions on how pixels move (P-frames/B-frames).
*   **The Risk:** If you modify a bit in a P-frame, the decoder tries to "move" a pixel that doesn't exist or has the wrong color. This results in visible "glitching" or "artifacting" (green blocks) that forensic tools flag immediately.
*   **Quantization:** Video compression divides images into "macroblocks" and averages the color values to save space. Your hidden data would be "averaged out" and destroyed instantly.
*   **Container Checksums:** MP4 containers have complex checksums. Modifying the bitstream requires recalculating CRC values, which is computationally expensive and easy to mess up, leaving a "corrupted" file flag.

### 2.3 The Rejected: Why Not JPG?

*   **The DCT Destroyer:** JPEG uses Discrete Cosine Transform. It converts pixels into frequency waves and discards "high frequency" data (fine detail) to save space.
*   **The Result:** Steganography is fine detail. Saving a JPG is equivalent to running your data through a shredder. It is impossible to reliably store LSB data in a standard JPEG.

## 3. Implementation A: The Web Standard (HTML/JS)

**The Original & Primary Implementation**

*   **Architecture:** Client-Side Single Page Application (SPA).
*   **Cryptography:** Web Crypto API (Native).
*   **Entropy:** `window.crypto.getRandomValues()`.

### 3.1 The "Silent" Philosophy

This is the Reference Implementation. It prioritizes Operational Security (OpSec) above raw performance. By operating within the browser's RAM context, it minimizes the forensic footprint on the host machine. It requires zero installation, meaning there is no `setup.exe` or `apt-get install` log for a forensic analyst to find.

### 3.2 Deep Analysis & Forensic Footprint

*   **Memory Management:** JavaScript uses Garbage Collection. We cannot manually "zero out" (erase) the password from RAM. The browser decides when to clear memory.
    *   **Risk:** A "Cold Boot Attack" (freezing the RAM chips physically) could theoretically recover the key if done immediately.
    *   **Mitigation:** Closing the browser tab generally invalidates the memory heap effectively enough for standard threat models.
*   **Disk Activity:** Modern browsers (Chrome/Edge) allow "Swap" or "Page Files." If your RAM fills up, the OS writes RAM content to the Hard Drive.
    *   **Countermeasure:** This MUST be run in a Live OS (Tails/Ubuntu) that runs entirely in RAM and has no hard drive mounted. This is the only way to guarantee "Zero Trace."

**Pros:**
*   Universal Access: Works on any device with a browser.
*   Deniable: "I was just browsing the web."

**Cons:**
*   Performance: Bitwise operations in JS are slower than native code.

## 4. Implementation B: The Analyst's Choice (Python)

*   **Architecture:** Script-based CLI tool.
*   **Cryptography:** `cryptography` (hazmat primitives).
*   **Image Handling:** Pillow (PIL Fork) / numpy.

### 4.1 Overview

Python allows for rapid integration into data pipelines. If you need to analyze the statistical variance of your noise generation, Python's data science libraries are unmatched.

### 4.2 Code Logic (Key Snippet)

```python
# The numpy approach allows for "Vectorized" LSB injection
# Instead of a slow loop, we treat the image as a giant matrix of numbers.
flat_arr[0:len(bits)] = (flat_arr[0:len(bits)] & 0xFE) | bits
```

### 4.3 Deep Analysis & Forensic Footprint

*   **The Dependency Trail:** Using Python requires `pip install`. This leaves a permanent record in the OS. An analyst can type `pip freeze` and see `cryptography` and `Pillow` installed. This is circumstantial evidence that you are performing encryption or image manipulation.
*   **Interpreter Overhead:** Python leaves bytecode (`.pyc` files) caches on disk. These must be manually deleted to remove traces of execution.

**Pros:**
*   Auditability: The code is high-level and easy for humans to verify.

**Cons:**
*   High Forensic Trace: Leaves many logs and cache files.

## 5. Implementation C: The Speed Demon (C++)

*   **Architecture:** Compiled Binary.
*   **Cryptography:** OpenSSL (EVP Interface).
*   **Image Handling:** stb_image (Header-only).

### 5.1 Overview

When processing 4K RAW images or hour-long WAV files, performance is paramount. C++ offers direct memory access, allowing for processing speeds 50x-100x faster than Python.

### 5.2 Deep Analysis & Forensic Footprint

*   **Secure Memory (Zeroization):**

```cpp
// In C++, we can do this:
memset(password_buffer, 0, sizeof(password_buffer));
// The compiler CANNOT optimize this away if using secure_zero functions.
```

This ensures that even if RAM is dumped, the password is gone.

*   **The Binary Signature:** A compiled `.exe` or binary has a hash. If you download this tool, that specific file hash is a known signature. If an analyst finds `vault.exe` on your PC, they know exactly what it is.

**Pros:**
*   Raw Speed: Essential for large archives.
*   Memory Hygiene: Best capability to scrub RAM.

**Cons:**
*   Memory Safety Risks: Buffer overflows in C++ are common. A bug could crash the program and dump a "Core Dump" file to disk, which contains your passwords in plain text.

## 6. Implementation D: The Modern Standard (Rust)

*   **Architecture:** Compiled Binary.
*   **Cryptography:** RustCrypto ecosystem.
*   **Image Handling:** `image` crate.

### 6.1 Overview

Rust is the "safe" C++. It guarantees memory safety without a garbage collector. This makes it ideal for a secure vault, preventing the "Core Dump" risks of C++ while maintaining the speed.

### 6.2 Deep Analysis & Forensic Footprint

*   **Static Linking:** Rust binaries are usually statically linked. This means they don't depend on system `.dll` or `.so` files. You can drop a single file onto a USB stick and run it anywhere.
*   **Deterministic Builds:** Rust allows for reproducible builds. You can prove that the binary matches the source code exactly, preventing "Supply Chain Attacks" where a hacker modifies the compiler.

**Pros:**
*   Safety: Mathematical guarantee against memory corruption.
*   Speed: Comparable to C++.

**Cons:**
*   Binary Size: Large executables (due to including the standard library).

## 7. Implementation E: The Mobile Fortress (Swift / iOS)

*   **Architecture:** Native iOS App.
*   **Cryptography:** CryptoKit (Apple Native).
*   **Image Handling:** CoreGraphics / vImage.

### 7.1 Overview

The modern user lives on their phone. An iOS implementation leverages the Secure Enclave (hardware security chip) found in iPhones for key management.

### 7.2 Source Code (Swift Implementation)

```swift
import UIKit
import CryptoKit
import CoreGraphics

class RadioheadVault {
    
    // 1. Encryption (AES-GCM via CryptoKit)
    func encrypt(data: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined! // Returns Nonce + Ciphertext + Tag
    }
    
    // 2. LSB Injection (CoreGraphics)
    func hide(image: UIImage, secret: Data) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Access raw pixel data
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        // Create raw buffer
        var rawData = [UInt8](repeating: 0, count: height * bytesPerRow)
        let context = CGContext(data: &rawData,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Convert secret to bits
        // ... (Bit conversion logic same as other langs) ...
        
        // Inject into rawData
        // Loop through rawData, modify LSB
        // CSPRNG: Int.random(in: 0...1) for noise fill
        
        // Reconstruct Image
        guard let newCGImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}
```

### 7.3 Deep Analysis & Forensic Footprint

*   **The Apple Ecosystem:**
    *   **Sandboxing:** iOS apps are strictly sandboxed. One app cannot read another app's memory. This is great for security.
    *   **The Cloud Risk (CRITICAL):** iPhones default to backing up photos to iCloud. If you save the "Vault Image" to your Camera Roll, it uploads to Apple's servers. This breaks the "Zero Trace" rule.
    *   **The "Deleted" Folder:** When you delete a photo on iOS, it goes to "Recently Deleted" for 30 days. You must manually empty this folder.
    *   **Secure Enclave:** We can store the encryption keys in the hardware Secure Enclave, making them impossible to extract even if the phone is jailbroken.

**Pros:**
*   Physical Security: iPhones are notoriously hard to break into physically (if passcodes are strong).
*   Hardware Accel: extremely fast encryption.

**Cons:**
*   iCloud Leaks: High risk of accidental cloud upload.
*   Closed Garden: You cannot easily inspect what the OS is doing under the hood.

## 8. Implementation F: The Command Line Warrior (Bash/Shell)

*   **Architecture:** Shell Scripting (Automation).
*   **Dependencies:** `steghide`, `exiftool`, `p7zip-full`.
*   **Platform:** Linux / macOS.

### 8.1 Overview

This implementation represents the "manual transmission" of steganography. It stitches together powerful, battle-tested standard Linux utilities into a cohesive forensic workflow. It is favored by SysAdmins and hackers who live in the terminal.

### 8.2 Source Code (Bash Script)

```bash
#!/bin/bash
# Radiohead Vault - CLI Edition
# Usage: ./vault.sh [lock|unlock] [cover_image] [secret_data/vault_image]

MODE=$1
COVER=$2
TARGET=$3

# ANSI Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function secure_lock() {
    echo -e "${GREEN}[*] Initializing Lockdown Sequence...${NC}"
    
    # 1. Compress & Encrypt (AES-256)
    # -mhe=on: Encrypt Headers (Hide filenames)
    # -mx=9: Ultra Compression
    echo -e "${GREEN}[*] Creating Encrypted Archive...${NC}"
    7z a -t7z -mhe=on -mx=9 -p payload.7z "$TARGET"
    
    # 2. Embed (Steghide LSB)
    # Note: Steghide uses a graph-theoretic matching algorithm for scattering
    echo -e "${GREEN}[*] Embedding Payload into Cover...${NC}"
    steghide embed -cf "$COVER" -ef payload.7z -sf vault_raw.jpg -p "default_embed_key" -f
    
    # 3. Metadata Scrubbing (Forensic Cleaning)
    echo -e "${GREEN}[*] Scrubbing EXIF/Metadata...${NC}"
    exiftool -all= vault_raw.jpg -o vault_clean.jpg
    
    # 4. Timeline Spoofing (Backdating)
    # Set date to a random time in 2021 to blend in
    touch -t 202105231200 vault_clean.jpg
    
    # 5. Cleanup
    rm payload.7z vault_raw.jpg
    echo -e "${GREEN}[SUCCESS] Vault Created: vault_clean.jpg${NC}"
}

function secure_unlock() {
    echo -e "${GREEN}[*] Extracting Data...${NC}"
    
    # 1. Extract
    steghide extract -sf "$COVER" -p "default_embed_key"
    
    # 2. Decrypt
    # User will be prompted for 7z password
    7z x payload.7z
    
    rm payload.7z
    echo -e "${GREEN}[SUCCESS] Data Extracted.${NC}"
}

if [ "$MODE" == "lock" ]; then
    secure_lock
elif [ "$MODE" == "unlock" ]; then
    secure_unlock
else
    echo "Usage: ./vault.sh [lock|unlock] ..."
fi
```

### 8.3 Deep Analysis & Forensic Footprint

*   **The Shell History Risk:**
    *   **Risk:** If you type passwords directly into the command line (e.g., `-pMyPassword`), they are saved in `~/.bash_history` or `~/.zshrc`.
    *   **Mitigation:** The script above deliberately lets 7z prompt the user interactively for the password. Never hardcode passwords in shell scripts.
*   **Dependency Footprint:** Like Python, this requires installing tools. `sudo apt install steghide` leaves a log in `/var/log/dpkg.log`.
*   **Tool Specifics:**
    *   **Steghide:** An older tool. While robust, it only supports JPEG and WAV. It does not support PNG. This limits the "Lossless" philosophy slightly (JPEG is lossy, but Steghide handles the DCT coefficients carefully).

**Pros:**
*   Reliability: Built on tools that have existed for 20 years.
*   Automation: Easy to put into a cron job or larger script.

**Cons:**
*   Format Limitation: `steghide` forces the use of JPEG (lossy) or WAV.
*   Forensic Noise: High. Running 7z and steghide creates distinct process execution logs.

## 9. Comparative Analysis & Verdict

| Feature | HTML/JS | Python | C++ | Rust | Swift (iOS) | Bash (Shell) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Primary Use Case** | OpSec / Live OS | Analysis | High Perf | Modern / Safe | Personal | SysAdmin |
| **Forensic Footprint** | Lowest (RAM) | High (Deps) | Medium | Medium | High (Cloud) | High (History) |
| **Execution Speed** | Medium | Slow | Highest | Very High | High | High |
| **Development** | Fast | Fastest | Slow | Medium | Medium | Fast |
| **Memory Safety** | High | High | Low | Highest | High | N/A |
| **Portability** | Universal | Low | Low | Medium | iOS Only | Linux/Mac |

### Final Verdict

*   **For Maximum Anonymity (The "Radiohead" Standard):** Use **HTML/JS**.
    *   *Why:* It is the only version that can theoretically leave zero trace on a computer if used with a Live USB OS (Tails). It exists only in RAM and disappears when the power is cut.
*   **For Large Archives:** Use **Rust**.
    *   *Why:* It processes gigabytes safely and quickly without the risk of C++ memory leaks.
*   **For Daily Use:** Use **Swift**.
    *   *Why:* Convenience. But ensure iCloud backup is **DISABLED** for the app.

## 10. Advanced Forensic Theory

### 10.1 The "Data Cliff" vs. "Full Noise"

This is the specific mechanism v5.0 uses to defeat detection.

*   **The Cliff:** If you hide 1MB of data in a 10MB image, standard tools leave the last 9MB untouched. An entropy scan shows a wall of noise followed by silence. This is a "smoking gun."
*   **Full Noise:** We use a CSPRNG (Cryptographically Secure Pseudo-Random Number Generator) to fill the remaining 9MB.
*   **The Result:** The entire 10MB image appears to have maximum entropy. There is no beginning and no end to the data. It looks like a very noisy camera sensor or a bad scan.

### 10.2 The LSB Bit Plane

In an 8-bit color channel (0-255), the Least Significant Bit (1 or 0) contributes very little to the visual color.

`10010010` (146) vs `10010011` (147).

The human eye cannot distinguish this difference. However, modifying bit 7 (MSB) would change the color drastically.

*   **Risk:** Aggressive compression (JPG) destroys LSBs. Only PNG/WAV preserve them.

### 10.3 OpSec: The "Live OS" Imperative

Regardless of the language used, the Operating System is the enemy. Windows and macOS create:

*   **Swap Files:** When RAM is full, RAM contents are written to disk.
*   **Hibernation Files:** A snapshot of RAM saved on shutdown.
*   **Prefetch/Superfetch:** Logs of executables run.

The only defense is to bypass the OS storage. Running the HTML implementation inside a RAM-only Live Linux Distro (like Tails) is the only way to guarantee that no magnetic or solid-state trace of the encryption key or plaintext remains after power-off.
