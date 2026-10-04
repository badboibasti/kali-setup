#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> Updating package lists..."
sudo apt update

echo "==> Upgrading system..."
sudo apt full-upgrade -y

echo "==> Installing packages..."

# Remote access
sudo apt install -y \
    openssh-server \
    openvpn \
    xauth \
    zsh

# Reconnaissance & scanning
sudo apt install -y \
    nmap \
    seclists \
    dnsutils \
    whois

# Web enumeration & testing
sudo apt install -y \
    ffuf \
    burpsuite \
    firefox-esr 

# Network & SMB
sudo apt install -y \
    netcat-openbsd \
    smbclient

# Exploitation
sudo apt install -y \
    metasploit-framework \
    exploitdb

# Privilege Escalation
sudo apt install -y \
    peass

echo "==> Updating Searchsploit Database..."
searchsploit -u

echo "==> Verifying Searchsploit..."
if command -v searchsploit >/dev/null 2>&1; then
    echo "    Searchsploit is installed."
else
    echo "    ERROR: Searchsploit installation failed."
    exit 1
fi

# Updating Searchsploit Database
searchsploit -u

# Programming & scripting
sudo apt install -y \
    python3-pip \
    python3-venv \
    jq

# General CLI utilities
sudo apt install -y \
    curl \
    wget \
    vim \
    git \
    fastfetch

echo "==> Configuring Zsh..."

ZSHRC="$HOME/.zshrc"

if ! grep -qxF 'fastfetch' "$ZSHRC" 2>/dev/null; then
    printf '\nfastfetch\n' >> "$ZSHRC"
    echo "    Added fastfetch to $ZSHRC"
else
    echo "    fastfetch is already configured."
fi

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

