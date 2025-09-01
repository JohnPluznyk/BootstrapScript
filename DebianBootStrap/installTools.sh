#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "[-] Please run this script with sudo:"
    echo "    sudo $0"
    exit 1
fi

# Check if tools.list exists
if [[ ! -f "tools.list" ]]; then
    echo "[-] tools.list not found!"
    echo "[*] Create a tools.list file with one package name per line."
    exit 1
fi

echo "[+] Updating package lists..."
apt update -y

echo "[+] Installing packages from tools.list..."
apt install $(tr '\n' ' ' < tools.list) -y

echo "[+] Installation completed!"
