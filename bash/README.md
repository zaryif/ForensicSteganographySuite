# Radiohead Vault - Bash CLI 🐚

This directory contains a shell script wrapper for standard Linux steganography tools. It provides a quick way to automate secure hiding using `7zip` (for encryption) and `steghide` (for hiding).

## 📋 Prerequisites

You must have the following tools installed on your system:

1.  **7zip** (with encryption support)
    *   Ubuntu/Debian: `sudo apt install p7zip-full`
    *   macOS: `brew install p7zip`
2.  **Steghide**
    *   Ubuntu/Debian: `sudo apt install steghide`
    *   macOS: `brew install steghide`

## 🚀 Usage

Make the script executable first:
```bash
chmod +x vault.sh
```

### Locking (Hide Data)
Encodes a secret file into a cover image.

```bash
# Syntax: ./vault.sh lock <SECRET_FILE> <COVER_IMG> <PASSWORD>
./vault.sh lock ../tutorial_assets/CONFIDENTIAL.pdf ../tutorial_assets/cover.png MySafePass
```

### Unlocking (Retrieve Data)
Extracts the secret file from the steganographic image.

```bash
# Syntax: ./vault.sh unlock <SECRET_FILE_NAME> <STEGO_IMG> <PASSWORD>
./vault.sh unlock extracted_data.7z ../tutorial_assets/cover.png MySafePass
```
*(Note: Since `steghide` extracts the original filename inside the archive, the second argument here acts as a placeholder or output path depending on your steghide version behavior).*
