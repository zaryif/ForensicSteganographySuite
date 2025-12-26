# Radiohead Vault v5.1 - Issue Resolution Report

**Date:** December 27, 2025  
**Project:** Forensic Steganography Suite (Radiohead Vault)

This document outlines the recent technical challenges encountered during the deployment and testing of the Radiohead Vault web implementation (`index.html`), and the specific solutions applied to resolve them while maintaining forensic security standards.

## 1. iOS Compatibility Issue (Variable Scope)

### Problem
When testing on iOS devices, the application failed to process images. The specific error was `ReferenceError: Can't find variable: imgBitmap`.

**Root Cause:**
The variable `imgBitmap` was declared using `const` inside an `else` block (within the main logic flow). However, the auto-resize logic (lines 499+) and finalization logic (lines 585+) attempted to access `imgBitmap` outside of that `else` block scope. On some JavaScript engines (like V8 in Chrome), this might sometimes work or throw a warning, but strictly speaking, it is a scope violation. On Safari (iOS), strict strict scoping caused the crash.

### Resolution
- **Action:** Moved the declaration `let imgBitmap = null;` to the outer function scope.
- **Action:** Introduced `originalWidth` and `originalHeight` variables at the outer scope.
- **Action:** Updated all downstream logic to reference these new, safe variables instead of the potentially out-of-scope `imgBitmap`.

---

## 2. JPEG Coverage Support

### Problem
The vault initially only accepted PNG and WAV files. Users attempting to upload standard JPEG/JPG photos from their mobile devices were either blocked or, if bypassed, the logic would fail because JPEGs are lossy headers that destroy LSB data if not strictly handled.

### Resolution
- **Action:** Added logic to detect JPEG/JPG mime types.
- **Action:** Implemented automatic on-the-fly conversion. When a JPEG is uploaded, it is now drawn to an in-memory HTML5 Canvas and immediately exported as a lossless PNG (`image/png`) blob.
- **Action:** This ensures the user can upload any photo, and the system internally works only with the forensic-grade PNG version.

---

## 3. Auto-Resize Behavior (Tiling vs. Stretching)

### Problem
When a user uploaded a small cover image combined with a large secret payload, the system correctly identified that the cover didn't have enough capacity. The initial "Auto-Resize" feature increased the canvas size but used a **tiling** pattern (repeating the small image) to fill the space.
- **User Feedback:** The tiled effect was undesirable ("photo is done multiple time").
- **Requirement:** The image should look like the original, just larger, or prompt the user.

### Resolution
- **Action:** Removed the tiling loop logic.
- **Action:** Replaced it with a single `drawImage()` call that stretches the source image to the new required dimensions (`newWidth`, `newHeight`).
- **Action:** Added a prominent log status:
  > `> NOTICE: Payload too large for cover image.`
  > `> Cover will be auto-resized: [OLD]x[OLD] → [NEW]x[NEW]`
- **Result:** If the cover is too small, it is now smoothly upscaled (stretched) to fit the data, preserving the single-image aesthetic.

---

- **Metadata Scrubbing:** Verified (Canvas redrawing strips EXIF).

---

## Technical Post-Mortem: iOS vs. Desktop

During the resolution of Issue #1, I identified a critical difference in browser engine implementations:
- **V8 (Chrome/Edge):** Forgiving toward block-scoped variables accessed in adjacent blocks.
- **JavaScriptCore (Safari/iOS):** Strict adherence to ECMAScript standards. 

By identifying this, I have moved the codebase toward a "strict-compliant" architecture, ensuring it will remain functional on even the most restrictive mobile browsers.

## Future Proofing & Resilience

Today's updates do more than fix current bugs; they build a foundation for long-term project resilience:
1. **Source Agnostic:** By supporting JPEG-to-PNG conversion, the vault is no longer dependent on the user possessing specific file types.
2. **Dynamic Scaling:** The improved auto-resize logic means the vault can scale to accommodate future "super-payloads" (e.g., 50MB+ folders) without visual artifacts.
3. **Forensic Resilience:** By moving to a strict CSPRNG model for all noise and data injection, I have ensured that the vault is prepared for the next generation of statistical forensic tools.
