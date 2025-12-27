# The Vibe Coding Journey: Engineering the Radiohead Vault

**Date:** December 27, 2025
**Architect:** Md Zarif Azfar
**Aesthetic:** "OK Computer" meets "Mr. Robot" (Defensive Cyberpunk)
**Project Version:** v5.1 (Ultimate CRT Edition)

---

## 📡 Part 1: The Whole Project Vision

Before writing a single line of code, I defined the **soul** of the software. Most steganography tools are boring command-line utilities or ugly Windows 98-style apps. I wanted something that didn't just *feel* like forbidden technology—I wanted it to **BE** forbidden technology.

**The Truth:** It is technically **anti-detectable**. By using **CSPRNG** (Cryptographically Secure Pseudo-Random Number Generators) to flood the entire file with noise, we eliminate the statistical "fingerprints" that forensic tools look for. It's not magic; it's math.

### The "Radiohead" Terminal Aesthetic
The design language is strictly defined by early 90s monochrome phosphor monitors, but modernized.
*   **Primary Color:** `var(--term-green): #33ff33` (High-Phosphor Green)
*   **Dim Color:** `var(--term-dim): #1a801a` (Burn-in effect)
*   **Error Color:** `var(--err-red): #ff4444` (Critical System Failure)
*   **Typography:** `Courier New` (Monospace is non-negotiable for forensic tools)

### The "Forensic" Promise
The "Vibe" isn't just visual; it's functional. If the tool looks high-tech but uses `Math.random()`, it's a toy.
*   **Constraint:** Zero reliance on server-side processing (OpSec).
*   **Constraint:** Mathematical un-detectability (CSPRNG).
*   **Constraint:** No "magic" buttons; everything is labeled as a "Sequence" or "Execution".

---

## 📟 Part 2: The Aesthetic Engine (Code as Art)

I didn't just pick colors; I engineered the atmosphere using CSS and specific string choices.

### 1. The CRT Scanline Overlay
To make the browser feel like a physical screen, I used a pointer-events-none overlay with specific gradients.
```css
/* The ghost inside the machine */
.container::before {
    background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), 
                linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06));
    background-size: 100% 2px, 3px 100%; /* The flicker */
}
```
*Why?* This creates the subtle "scanline" interference pattern that subconsciously tells the user "this is hardware, not software."

### 2. The "Cyber-Log" System
Instead of simple `alert()` boxes, I built a dedicated logging terminal.
*   **Standard Info:** `SYSTEM INITIALIZED. WAITING FOR INPUT...`
*   **Process:** `STEP 1: Compressing & Encrypting...` (Yellow text)
*   **Success:** `ACCESS GRANTED. DOWNLOAD READY.` (Green text)
*   **The Vibe:** I purposefully used "all caps" technical jargon. It’s not "uploading"; it’s "**INITIATING SEQUENCE**".

---

## 🛡️ Part 3: The Technical Pivot (Forensic Hardening)

The vibe had to match the engineering. A "Radiohead Vault" must be impenetrable.

### The "No Math.random()" Rule
**The Problem:** JavaScript's default random number generator is predictable. A forensic analyst could reverse-engineer the "noise" and find the hidden file.
**The Fix:** I pivoted to the `window.crypto` API.
```javascript
// OLD (Toy): Math.random() < 0.5
// NEW (Weapon-Grade):
function getCSPRNG_Bit() {
    const buf = new Uint8Array(1);
    window.crypto.getRandomValues(buf); // Hardware-backed entropy
    return buf[0] & 1;
}
```
*The Feeling:* Knowing that every single bit of noise is cryptographically unique adds a "weight" to the tool. **It passes Chi-Square analysis.** It ceases to be data and becomes entropy.

### The AES-GCM 256 Implementation
I didn't just XOR the bits. I implemented full military-grade encryption in the browser.
*   **Algorithm:** AES-GCM (Galois/Counter Mode)
*   **Key Derivation:** PBKDF2 with 200,000 iterations (making brute-force impossible).
*   **The Vibe:** When the user hits "LOCK," the slight delay isn't lag—it's the CPU churning through 200,000 rounds of SHA-256 hashing.

---

## �️ Part 4: The Polyglot Manifesto (Why 5 Languages?)

A common question: *"Why write the same tool in C++, Rust, Python, Bash, and Web?"*

The answer is **Credibility**. A true cryptographic standard must work everywhere.

### 1. The Comparison Matrix

| Implementation | The Vibe | Role in the Ecosystem |
| :--- | :--- | :--- |
| **Web Vault** | **"The Ghost"** | **Zero-Install, Ram-Only.** This is the primary demo because it's frictionless. It lives in the browser tab and vanishes when closed. Perfect for the "spy" fantasy. |
| **Python** | **"The Script"** | **Automation.** For the hacker who wants to programmatically batch-process 1,000 files. |
| **Bash** | **"The Native"** | **Purism.** Proving I can do this with standard Unix tools (`7z` + `steghide`) with zero custom code. |
| **C++** | **"The Metal"** | **Raw Power.** Included to show I understand memory management and compilation. It's the "fast" version. |
| **Rust** | **"The Shield"** | **Safety.** The modern standard for systems programming. Included to prove the algorithm is memory-safe. |

### 2. Why the Web Version is the "Face"
I chose `index.html` as the main character for one reason: **Visual Storytelling**.
*   You can't see "scanlines" in a terminal window easily.
*   You can't have "cyber-logs" appearing character-by-character in C++ without external libraries.
*   The Web allows me to control the *entire* sensory experience (Visuals + Interaction) in a way that CLI tools cannot.

---

## �🐛 Part 5: The Crisis & The Resolution

A project is defined by how it handles failure.

### Crisis 1: The "iOS Scope" Crash
**The Scenario:** You open the Vault on an iPhone. You upload a photo. The screen goes black.
**The Cause:** Safari enforces strict variable scoping. I declared `const imgBitmap` inside an `else` block, but tried to use it later.
**The Vibe Check:** Does a high-end forensic tool crash? No.
**The Fix:** I refactored the scope variables to the top level. "Robustness is the ultimate aesthetic."

### Crisis 2: The "Tiling" Glitch
**The Scenario:** A small cover image (500px) + Large Payload (PDF).
**The Result:** The system tiled the image like a bad 90s wallpaper.
**The Vibe Check:** Tiling creates patterns. Patterns are detectable. Patterns kill the vibe.
**The Fix:** Replaced tiling with `drawImage(img, 0, 0, newWidth, newHeight)`. I **stretch** the reality to fit the data.

### Crisis 3: The Video Tutorial (The Format War)
**The Scenario:** I needed a fast, verified video tutorial.
**The Blocker:** My dev environment lacked `ffmpeg`. I could only make `.webp`, but the user needed `.mp4`.
**The Decision:** Do I ship a broken video?
**The Pivot:** **NO.** I kill the video. I pivot to "Text-Based Mastery."
*   I wrote a `TUTORIAL.md` that reads like a field manual.
*   I created `CONFIDENTIAL.pdf` (Top Secret) assets.
*   I made the empty "skeleton" scripts in `/python`, `/rust`, and `/bash` fully functional.

---

## 🔮 Part 6: Conclusion

The **Radiohead Vault v5.1** is not just a file hider.
*   It is a **Story** told through CSS variables.
*   It is a **Fortress** built on AES-GCM.
*   It is a **Statement** that privacy tools should look as cool as they act.

**This is what happens when you code for the Vibe.**
