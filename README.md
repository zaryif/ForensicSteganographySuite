# Forensic-Grade Steganography Suite 
(v5.1 - ULTIMATE CRT EDITION)

**Architect:** Md Zarif Azfar
**License:** MIT
**Status:** Stable / Production-Ready

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/zaryif/ForensicSteganographySuite)
[![Live Demo](https://img.shields.io/badge/Live_Demo-Launch_Vault-success?style=for-the-badge&logo=html5)](https://zaryif.github.io/ForensicSteganographySuite/)

## Executive Summary

The **Radiohead Vault (Forensic-Grade Steganography Suite)** is the ultimate anti-forensic data storage solution. It secures sensitive encrypted data within lossless media files (PNG/WAV) using advanced Least Significant Bit (LSB) injection and **upgraded Cryptographically Secure Pseudo-Random Number Generators (CSPRNG)**.

**[Launch Live Web Vault](https://zaryif.github.io/ForensicSteganographySuite/)** (Runs entirely in browser RAM for maximum OpSec)

This **v5.1 CRT Edition** features a retro-terminal interface and eliminates statistical anomalies (entropy cliffs) by employing **Full-Surface Noise Injection**, making hidden data mathematically indistinguishable from random noise. It includes implementations in **HTML5, Python, C++, Rust, Swift, and Bash**.

## Repository Architecture

| Directory | Language | Description | Forensic Profile |
| :--- | :--- | :--- | :--- |
| `/` (Root) | HTML5/JS | **Web Vault (Live Demo)**. Client-side execution in browser RAM. | Minimal (Zero Trace in Live OS) |
| `/python` | Python | Script-based implementation for automation and batch analysis. | High (Dependency Logs) |
| `/cpp` | C++ | High-performance binary for large-scale processing. | Medium |
| `/rust` | Rust | Memory-safe, high-performance binary implementation. | Medium |
| `/swift` | Swift | Native iOS implementation utilizing Secure Enclave. | High (Cloud Sync Risk) |
| `/bash` | Bash | Linux terminal automation using standard utilities. | High (Shell History) |

## Quick Start (Secure Environment)

For optimal Operational Security (OpSec), it is recommended to execute the Web implementation within a volatile memory environment (e.g., Tails OS).

1. Navigate to the root directory.
2. Launch `index.html` in a modern web browser.
3. Disconnect network interfaces to ensure an air-gapped environment.

## Documentation

*   [Technical Compendium (Ultimate Reference)](docs/TECHNICAL_COMPENDIUM.md)
*   [Complete Project History & Issues Report](COMPLETE_PROJECT_HISTORY.md)
*   [Recent Issue Resolution Report](issue_resolution_report.md)
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
├── COMPLETE_PROJECT_HISTORY.md  <-- PROJECT JOURNEY & RESOLUTIONS
├── issue_resolution_report.md  <-- RECENT PATCH NOTES
├── index.html  <-- WEB VAULT (v5.1 CRT)
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
