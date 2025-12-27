# Radiohead Vault - C++ Edition ⚡

This directory contains the high-performance C++ implementation. It requires manual compilation and linking against OpenSSL.

## 📋 Prerequisites

*   GCC (`g++`) or Clang
*   OpenSSL Development Libraries (`libssl-dev` on Ubuntu/Debian, `openssl` on macOS via Homebrew)

## 🛠️ Compilation

You must link against `ssl` and `crypto` libraries.

**Linux (Debian/Ubuntu):**
```bash
g++ vault.cpp -o vault -lssl -lcrypto
```

**macOS (if OpenSSL is installed via Homebrew):**
```bash
# You may need to specify paths if pkg-config cannot find it
g++ vault.cpp -o vault -I/opt/homebrew/opt/openssl/include -L/opt/homebrew/opt/openssl/lib -lssl -lcrypto
```

## 🚀 Usage

Run the compiled binary:

```bash
./vault
```

### Note
This codebase provides the cryptographic core functions (`encrypt` with AES-GCM). It is intended as a starting point for developers building high-performance steganography pipelines.
