
#!/usr/bin/env bash

set -Eeuo pipefail

# Run as a normal user with sudo privileges.
if (( EUID == 0 )); then
    echo "ERROR: Run this script as a normal user, not root." >&2
    exit 1
fi

sudo -v

export DEBIAN_FRONTEND=noninteractive

trap 'echo "ERROR: Command failed on line $LINENO: $BASH_COMMAND" >&2' ERR

log() {
    printf '\n==> %s\n' "$1"
}

# --------------------------------------------------
# System update
# --------------------------------------------------

log "Updating Kali Linux..."

sudo apt-get update
sudo apt-get full-upgrade -y

# --------------------------------------------------
# Wireshark configuration
# --------------------------------------------------

log "Configuring Wireshark permissions..."

echo "wireshark-common wireshark-common/install-setuid boolean true" |
    sudo debconf-set-selections

# --------------------------------------------------
# Package installation
# --------------------------------------------------

log "Installing penetration testing tools..."

PACKAGES=(
    # Remote access
    openssh-server
    freerdp3-x11
    openvpn
    xauth
    netexec
    zsh

    # Reconnaissance and scanning
    nmap
    seclists
    dnsutils
    whois
    gowitness

    # Web enumeration and testing
    ffuf
    gobuster
    whatweb
    burpsuite
    firefox-esr

    # Network and SMB
    netcat-openbsd
    smbclient
    wireshark
    tshark
    tcpdump
    responder

    # Active Directory
    impacket-scripts
    evil-winrm
    ldap-utils
    bloodhound

    # Exploitation
    metasploit-framework

    # Password and hash cracking
    hashcat

    # Privilege escalation
    peass

    # Programming
    python3-pip
    python3-venv
    pipx
    jq

    # General CLI utilities
    curl
    wget
    vim
    git
    fastfetch
    tmux
    rlwrap
)

sudo apt-get install -y "${PACKAGES[@]}"

# --------------------------------------------------
# Wireshark group membership
# --------------------------------------------------

log "Configuring Wireshark group..."

if ! id -nG "$USER" | grep -qw wireshark; then
    sudo usermod -aG wireshark "$USER"
    echo "Wireshark group added. Re-login required."
fi

# --------------------------------------------------
# Zsh configuration
# --------------------------------------------------

log "Configuring Zsh..."

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

if ! grep -qxF 'fastfetch' "$ZSHRC"; then
    printf '\nfastfetch\n' >> "$ZSHRC"
fi

# --------------------------------------------------
# SSH configuration
# --------------------------------------------------

log "Enabling SSH..."

sudo systemctl enable --now ssh

if ! systemctl is-active --quiet ssh; then
    echo "ERROR: SSH service failed." >&2
    exit 1
fi

# --------------------------------------------------
# Tool verification
# --------------------------------------------------

log "Verifying essential tools..."

TOOLS=(
    ssh
    nmap
    ffuf
    nxc
    searchsploit
    msfconsole
    hashcat
    gowitness
)

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf "  [OK] %s\n" "$tool"
    else
        printf "  [MISSING] %s\n" "$tool"
        exit 1
    fi
done

# --------------------------------------------------
# Complete
# --------------------------------------------------

log "Kali setup complete!"

echo "Re-login to apply Wireshark group membership."
echo "Reboot if the system upgrade updated the kernel."

