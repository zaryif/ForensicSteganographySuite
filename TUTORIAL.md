# Forensic Steganography Suite - User Tutorial

Welcome to the **Radiohead Vault (Forensic-Grade Steganography Suite)**. This guide will help you secure your sensitive data using our advanced anti-forensic tools.

##  Quick Start (Web Vault)

The **Web Vault** is the primary, most secure way to use this suite. It runs entirely in your browser's RAM, leaving no trace on your hard drive (zero-footprint).

### 1. Launching the Vault
1.  Navigate to the `ForensicSteganographySuite-main` folder.
2.  Double-click `index.html` to open it in your web browser (Chrome, Firefox, Safari, Edge).
3.  **Security Tip:** For maximum security, disconnect your internet connection after the page loads. The tool works fully offline.

### 2. LOCK: Hiding Data (Encryption + Steganography)
**Try it yourself!** Use the sample files found in the `tutorial_assets` folder:
*   Secret File: `tutorial_assets/CONFIDENTIAL.pdf`
*   Cover Media: `tutorial_assets/cover.png`

1.  **Select "LOCK (Encrypt & Hide)"** tab (selected by default).
2.  **Secret Files**: Click `Choose Files` and select `CONFIDENTIAL.pdf` from the `tutorial_assets` folder.
    *   *Note: These will be automatically compressed into a ZIP archive.*
3.  **Cover Media**: Click `Choose File` and select `cover.png` from the `tutorial_assets` folder.
    *   **Supported Formats**: PNG images (`.png`) or WAV audio (`.wav`).
    *   *Note: JPEGs will be automatically converted to PNG, which may increase file size.*
4.  **Filename Camouflage (Optional)**: Enter a confusing name for the output file (e.g., `IMG_2025_holiday.png`). If left blank, a random name will be generated.
5.  **Encryption Password**: Enter a strong password. **Do not forget this password.** It is impossible to recover your data without it.
6.  **Initiate**: Click the **INITIATE SEQUENCE** button.
7.  **Download**: Once processing is complete, a **DOWNLOAD FILE** button will appear. click it to save your secure image/audio file.

#### ⚠️ Capacity & Auto-Resize
If your secret files are too large for the cover image, the system will **automatically resize** the cover image to make room. A notice will appear in the log if this happens.
*   *Audio (WAV) files cannot be resized. You must use a larger audio file if you run out of space.*

### 3. UNLOCK: Retrieving Data
Use this tab to extract your hidden files from a vault file.

1.  **Select "UNLOCK (Extract & Decrypt)"** tab.
2.  **Vault File**: Click `Choose File` and select the PNG or WAV file containing your hidden data.
3.  **Output Filename (Optional)**: Name the zip file you will extract (e.g., `MyRecoveredData.zip`).
4.  **Decryption Password**: Enter the **exact** password you used during the locking process.
5.  **Execute**: Click **EXECUTE EXTRACTION**.
6.  **Download**: Click **DOWNLOAD FILE** to save your decrypted ZIP file.

---

## 🛠️ Developer Tools (CLI Editions)

## 🛠️ Developer Guide (CLI Editions)

This section details how to run the standalone implementations found in the project folders.

### 🐍 1. Python Edition
**Location**: `/python/`
**Prerequisites**: Python 3.x, PIP

1.  **Install Dependencies**:
    ```bash
    cd python
    pip install -r requirements.txt
    ```
2.  **Run the Tool**:
    ```bash
    # Syntax: python3 vault.py <cover> <secret> <output> <password>
    python3 vault.py ../tutorial_assets/cover.png ../tutorial_assets/CONFIDENTIAL.pdf vault.png MySecretPass
    ```
3.  **Output**: You will see a `vault.png` file created in the `python` directory.

---

### 🦀 2. Rust Edition
**Location**: `/rust/`
**Prerequisites**: Rust (Cargo)

1.  **Navigate to directory**:
    ```bash
    cd rust
    ```
2.  **Run with Cargo**:
    ```bash
    cargo run
    ```
    *(Note: This is a skeleton logic implementation. It will compile and print a status message.)*

---

### 🐚 3. Bash Edition (Linux/Mac)
**Location**: `/bash/`
**Prerequisites**: `7zip` (`p7zip-full`), `steghide`

1.  **Make executable**:
    ```bash
    cd bash
    chmod +x vault.sh
    ```
2.  **Usage**:
    ```bash
    # Syntax: ./vault.sh <lock|unlock> <secret_file> <cover_file> <password>
    ./vault.sh lock ../tutorial_assets/CONFIDENTIAL.pdf ../tutorial_assets/cover.png MySafePass
    ```

---

### ⚡ 4. C++ Edition
**Location**: `/cpp/`
**Prerequisites**: GCC/Clang, OpenSSL (`libssl-dev`)

1.  **Compilation**:
    ```bash
    cd cpp
    g++ vault.cpp -o vault -lssl -lcrypto
    ```
2.  **Run**:
    ```bash
    ./vault
    ```
    *(Note: Requires OpenSSL installed on your system.)*

---

## 🛡️ Technical Security Notes

*   **Encryption**: AES-256-GCM (military-grade).
*   **CSPRNG**: Cryptographically Secure Pseudo-Random Number Generator used for noise injection.
*   **Anti-Forensics**: The tool fills the *entire* unused space of the image with random noise. This prevents forensic analysts from detecting "entropy cliffs" that usually reveal hidden data.
