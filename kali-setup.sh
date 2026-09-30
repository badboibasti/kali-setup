#!/usr/bin/env bash

set -euo pipefail

echo "==> Updating package lists..."
sudo apt update

echo "==> Upgrading system..."
sudo apt full-upgrade -y

echo "==> Installing packages..."

sudo apt install -y \
    # --- Remote access ---
    openssh-server \
    \
    # --- Reconnaissance & scanning ---
    nmap \
    seclists \
    dnsutils \
    whois \
    \
    # --- Web enumeration & testing ---
    ffuf \
    burpsuite \
    \
    # --- Network & SMB ---
    netcat-openbsd \
    smbclient \
    \
    # --- Exploitation ---
    metasploit-framework \
    \
    # --- Programming & scripting ---
    python3-pip \
    python3-venv \
    jq \
    \
    # --- General CLI utilities ---
    curl \
    wget \
    vim \
    fastfetch

echo "==> Enabling SSH..."
sudo systemctl enable --now ssh

echo "==> Verifying SSH..."
if systemctl is-active --quiet ssh; then
    echo "    SSH service is running."
else
    echo "    ERROR: SSH service failed to start."
    exit 1
fi

echo "==> Kali setup complete!"

