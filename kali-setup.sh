#!/usr/bin/env bash

set -euo pipefail

echo "==> Updating package lists..."
sudo apt update

echo "==> Upgrading system..."
sudo apt full-upgrade -y

echo "==> Installing packages..."
sudo apt install -y \
    openssh-server \
    nmap \
    seclists \
    netcat-openbsd \
    fastfetch \
    curl \
    wget \
    vim \
    jq \
    python3-pip \
    python3-venv \
    dnsutils \
    whois \
    smbclient \
    ffuf \
    metasploit-framework

echo "==> Enabling SSH..."
sudo systemctl enable --now ssh

echo "==> Verifying SSH..."
systemctl is-active --quiet ssh

echo "==> Kali setup complete!"

