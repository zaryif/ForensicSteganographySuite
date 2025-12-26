# Forensic-Grade Steganography Suite (v5.0)

**Architect:** Md Zarif Azfar
**License:** MIT
**Status:** Stable / Production-Ready

## Executive Summary

The Forensic-Grade Steganography Suite is a comprehensive set of implementations designed for Anti-Forensic Data Storage. The system secures sensitive encrypted data within lossless media files (PNG/WAV) utilizing Least Significant Bit (LSB) injection. It distinguishes itself from standard steganographic tools by employing Cryptographically Secure Pseudo-Random Number Generators (CSPRNG) to eliminate statistical anomalies (entropy cliffs), thereby mitigating detection by standard forensic analysis tools.

## Repository Architecture

| Directory | Language | Description | Forensic Profile |
| :--- | :--- | :--- | :--- |
| `/web` | HTML5/JS | Client-side execution in browser RAM. Recommended for high-security contexts. | Minimal (Zero Trace in Live OS) |
| `/python` | Python | Script-based implementation for automation and batch analysis. | High (Dependency Logs) |
| `/cpp` | C++ | High-performance binary for large-scale processing. | Medium |
| `/rust` | Rust | Memory-safe, high-performance binary implementation. | Medium |
| `/swift` | Swift | Native iOS implementation utilizing Secure Enclave. | High (Cloud Sync Risk) |
| `/bash` | Bash | Linux terminal automation using standard utilities. | High (Shell History) |

## Quick Start (Secure Environment)

For optimal Operational Security (OpSec), it is recommended to execute the Web implementation within a volatile memory environment (e.g., Tails OS).

1. Navigate to the `web/` directory.
2. Launch `index.html` in a modern web browser.
3. Disconnect network interfaces to ensure an air-gapped environment.

## Documentation

*   [Technical Compendium (Ultimate Reference)](docs/TECHNICAL_COMPENDIUM.md)
*   [Technical Overview](docs/TECHNICAL_OVERVIEW.md)
*   [System Requirements](docs/SYSTEM_REQUIREMENTS.txt)
*   [USB Access Protocol](docs/USB_ACCESS_PROTOCOL.txt)

## Repository Structure

```
RadioheadVault/
├── docs/
│   ├── TECHNICAL_COMPENDIUM.md
│   ├── TECHNICAL_OVERVIEW.md
│   ├── SYSTEM_REQUIREMENTS.txt
│   └── USB_ACCESS_PROTOCOL.txt
├── web/
│   └── index.html
├── python/
│   └── vault.py
├── cpp/
│   └── vault.cpp
├── rust/
│   └── main.rs
├── swift/
│   └── RadioheadVault.swift
├── bash/
│   └── vault.sh
├── windows/
│   └── vault.bat
└── README.md
```

## Disclaimer

This software is provided for educational and defensive security research purposes only. The author assumes no liability for the application of this tool.
