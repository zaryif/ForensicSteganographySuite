# PDF Steganography Tutorial (Web Vault)

This guide demonstrates how to securely hide a **PDF document** inside an **Image (PNG/JPEG)** or **Audio (WAV)** carrier using the Radiohead Vault (Web Edition).

> [!IMPORTANT]
> The Web Vault uses **browser-based encryption**. Your files never leave your device.

## Prerequisites

1. **Radiohead Vault** (`index.html`) open in your browser.
2. A **PDF file** to hide (e.g., `CONFIDENTIAL.pdf`).
3. A **Cover Media** file:
   * **Images:** PNG, JPEG, or JPG (Lossy formats like JPEG are automatically converted to lossless PNG).
   * **Audio:** WAV format.
   * Note: Larger high-resolution images provide more data capacity and better visual results.

---

## Part 1: Hiding the PDF (LOCK)

1.  **Open the Vault**: Launch `index.html` in your web browser.
2.  **Select Tab**: Ensure you are on the **LOCK (Encrypt & Hide)** tab.
3.  **Upload Secret**: Click "Choose Files" under **1. Secret Files** and select your PDF file.
    * *Note: The system automatically zips input files.*
4.  **Upload Cover**: Click "Choose File" under **2. Cover Media** and select your image or audio file.
    * The system will analyze the carrier for bit-capacity. If the carrier is too small for the PDF, the vault will automatically resize (stretch) the image to fit.
    * Review the terminal log for notifications: `NOTICE: Payload too large for cover image`.
5.  **Set Password**: Enter a strong password in **4. Encryption Password**.
6.  **Execute**: Click **INITIATE SEQUENCE**.
    * The system will encrypt the PDF, inject it into the image bits, and fill the rest with noise.
7.  **Download**: Click the **DOWNLOAD FILE** link when it appears.
    * You will save a file like `IMG_1234.png`. This image looks like noise (or your cover image with noise) but contains your encrypted PDF.

---

## Part 2: Extracting the PDF (UNLOCK)

1.  **Select Tab**: Switch to the **UNLOCK (Extract & Decrypt)** tab.
2.  **Upload Vault File**: Click "Choose File" under **1. Vault File** and select the standard PNG file you downloaded earlier.
3.  **Enter Password**: Enter the same password used during encryption.
4.  **Execute**: Click **EXECUTE EXTRACTION**.
5.  **Download**: Click **DOWNLOAD FILE** to get `UNLOCKED_DATA.zip`.
6.  **Unzip**: Open the ZIP file to find your original PDF.

---

## Troubleshooting

- **Image Quality**: If the output image appears pixelated, it means the original cover was too small and the system had to auto-resize (stretch) it significantly to accommodate the PDF. Using a larger cover image will resolve this.
- **Decryption Failed**: Ensure the exact same password is used. The Radiohead Vault uses a zero-knowledge architecture; there is no password recovery mechanism.
- **File Format**: Ensure you are using supported formats (WAV for audio, PNG/JPEG for images). Other formats may not be processed correctly.
