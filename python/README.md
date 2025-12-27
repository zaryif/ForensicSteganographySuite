# Radiohead Vault - Python Edition 🐍

This directory contains the Python implementation of the Forensic Steganography Suite. It uses `cryptography` for encryption and `Pillow` (PIL) for image manipulation.

## 📋 Prerequisites

*   Python 3.8 or higher
*   pip (Python Package Manager)

## 🛠️ Installation

1.  Navigate to this directory:
    ```bash
    cd python
    ```
2.  Install the required dependencies:
    ```bash
    pip install -r requirements.txt
    ```

## 🚀 Usage

The script `vault.py` is a command-line tool.

### Syntax
```bash
python3 vault.py <COVER_IMAGE> <SECRET_FILE> <OUTPUT_IMAGE> <PASSWORD>
```

### Examples

**Hiding Data (Locking):**
```bash
# Hide the secret PDF inside cover.png and save as vault.png
python3 vault.py ../tutorial_assets/cover.png ../tutorial_assets/CONFIDENTIAL.pdf vault.png MyStrongPass
```

**Note on Unlocking:**
The verification/unlock logic is implied in the cryptographic structure. To extend this tool for decryption, please refer to the `decrypt` functions in the source code or use the Web Vault for full round-trip verification.
