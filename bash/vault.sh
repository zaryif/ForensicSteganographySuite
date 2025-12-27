#!/bin/bash
# Radiohead Vault - CLI
# Architect: Md Zarif Azfar

echo "Radiohead Vault CLI"

# Check for dependencies
if ! command -v 7z &> /dev/null; then
    echo "Error: 7z is not installed. Please install p7zip-full."
    exit 1
fi
if ! command -v steghide &> /dev/null; then
    echo "Error: steghide is not installed. Please install steghide."
    exit 1
fi

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <mode: lock|unlock> <file> <cover> <password>"
    echo "Example: $0 lock secret.txt cover.jpg mypassword"
    exit 1
fi

MODE=$1
FILE=$2
COVER=$3
PASS=$4

if [ "$MODE" == "lock" ]; then
    echo "[*] Compressing..."
    7z a -p"$PASS" payload.7z "$FILE"
    echo "[*] Embedding..."
    steghide embed -cf "$COVER" -ef payload.7z -p "$PASS"
    echo "[+] Done. Data hidden in $COVER"
    rm payload.7z
elif [ "$MODE" == "unlock" ]; then
    echo "[*] Extracting..."
    steghide extract -sf "$COVER" -p "$PASS"
    echo "[+] Done. Extracted payload.7z"
fi
