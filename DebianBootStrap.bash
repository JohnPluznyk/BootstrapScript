#!/bin/bash

# ==============================
#   Debian Bootstrap Script
#   Author: jp
#   Description: Installs i3wm + Polybar + essential tools
# ==============================

# Exit immediately if a command fails
set -e

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}[ERROR]${RESET} Please run this script as root (use sudo)."
  exit 1
fi

echo -e "${GREEN}[*] Updating system packages...${RESET}"
apt update && apt upgrade -y

echo -e "${GREEN}[*] Installing essential packages...${RESET}"
apt install -y \
  xserver-xorg \
  xinit \
  feh \
  kitty \
  i3 \
  polybar \
  fonts-jetbrains-mono \
  curl \
  git \
  unzip \
  wget \
  build-essential \
  pavucontrol \
  pulseaudio \
  network-manager \
  neofetch

echo -e "${GREEN}[*] Installation complete!${RESET}"

# Set Kitty as default terminal if installed
if command -v kitty &> /dev/null; then
  echo -e "${GREEN}[*] Setting Kitty as default terminal...${RESET}"
  update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 50
  update-alternatives --set x-terminal-emulator $(which kitty)
else
  echo -e "${YELLOW}[WARN] Kitty not found, skipping default terminal setup.${RESET}"
fi

# Setup basic i3 config if not exists
I3_CONFIG="$HOME/.config/i3/config"
if [[ ! -f "$I3_CONFIG" ]]; then
  echo -e "${GREEN}[*] Creating default i3 config...${RESET}"
  mkdir -p "$HOME/.config/i3"
  cp /etc/i3/config "$I3_CONFIG"
fi

# Optional: Create basic Polybar config
POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"
if [[ ! -f "$POLYBAR_CONFIG" ]]; then
  echo -e "${GREEN}[*] Creating default Polybar config...${RESET}"
  mkdir -p "$HOME/.config/polybar"
  cp /usr/share/doc/polybar/config $POLYBAR_CONFIG 2>/dev/null || echo "; Default Polybar config" > "$POLYBAR_CONFIG"
fi

# Ask user about reboot
echo -e "${YELLOW}[*] Do you want to reboot now? (y/*]()
