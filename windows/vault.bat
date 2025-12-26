@echo off
REM Forensic Steganography Suite - Windows CMD Edition
REM Architect: Md Zarif Azfar
REM Dependencies: 7-Zip (7z.exe), ExifTool (exiftool.exe) MUST be in system PATH

TITLE Forensic Steganography Suite
COLOR 0A

:MENU
CLS
ECHO =================================================
ECHO    FORENSIC STEGANOGRAPHY SUITE (Windows)
ECHO    Architect: Md Zarif Azfar
ECHO =================================================
ECHO 1. LOCK (Encrypt and Hide)
ECHO 2. UNLOCK (Extract and Decrypt)
ECHO 3. EXIT
ECHO =================================================
SET /P M=Type 1, 2, or 3 then press ENTER: 
IF %M%==1 GOTO LOCK
IF %M%==2 GOTO UNLOCK
IF %M%==3 GOTO EOF

:LOCK
CLS
ECHO [LOCK SEQUENCE INITIATED]
SET /P FOLDER=Enter folder name to hide: 
SET /P COVER=Enter cover image filename (e.g., cover.png): 
SET /P OUTPUT=Enter output filename (e.g., vault.png): 

ECHO.
ECHO [*] Encrypting Payload (AES-256)...
7z a -t7z -mhe=on -mx=9 -p payload.7z "%FOLDER%"

ECHO.
ECHO [*] Injecting Payload into Image Structure...
COPY /B "%COVER%" + payload.7z raw_vault.png

ECHO.
ECHO [*] Scrubbing Metadata...
exiftool -all= raw_vault.png -o "%OUTPUT%"

ECHO.
ECHO [*] Cleaning Evidence...
DEL payload.7z
DEL raw_vault.png

ECHO.
ECHO [SUCCESS] Secure file created: %OUTPUT%
PAUSE
GOTO MENU

:UNLOCK
CLS
ECHO [UNLOCK SEQUENCE INITIATED]
SET /P VAULT=Enter vault filename (e.g., vault.png): 

ECHO.
ECHO [*] Renaming for Extraction...
COPY "%VAULT%" payload_retrieve.7z

ECHO.
ECHO [*] Decrypting Payload...
7z x payload_retrieve.7z

ECHO.
ECHO [*] Cleanup...
DEL payload_retrieve.7z

ECHO.
ECHO [SUCCESS] Data extracted.
PAUSE
GOTO MENU

:EOF
EXIT
