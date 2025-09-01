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
  alsa-utils \
  htop \
  firefox-esr \
  openvpn

echo -e "${GREEN}[*] Installation complete!${RESET}"

# Set Kitty as default terminal if installed
if command -v kitty &> /dev/null; then
  echo -e "${GREEN}[*] Setting Kitty as default terminal...${RESET}"
  update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 50
  update-alternatives --set x-terminal-emulator $(which kitty)
else
  echo -e "${YELLOW}[WARN] Kitty not found, skipping default terminal setup.${RESET}"
fi

# set up kitty config dir
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"
if [[ ! -f "$KITTY_CONFIG" ]]; then
  echo -e "${GREEN}[*] Creating default Kitty config...${RESET}"
  mkdir -p "$HOME/.config/kitty"
  cp -r ./kitty/* "$KITTY_CONFIG"
fi

# Setup basic i3 config if not exists
I3_CONFIG="$HOME/.config/i3/config"
if [[ ! -f "$I3_CONFIG" ]]; then
  echo -e "${GREEN}[*] Creating default i3 config...${RESET}"
  mkdir -p "$HOME/.config/i3"
  cp ./i3/config "$I3_CONFIG"
fi

#Create basic Polybar config
mkdir -p ~/.config/polybar
cp ./polybar/config.ini ~/.config/polybar/

# setup Wallpapers dir and move wallpapers
mkdir -p ~/Pictures/Wallpaper
cp ./Wallpaper/* ~/Pictures/Wallpaper/

# Copy .bashrc file into ~ directory
cp ./.bashrc ~

# Move your preconfigured .xinitrc into place
# Make sure your .xinitrc is in the same directory as this script
if [ -f "./.xinitrc" ]; then
    cp .xinitrc ~/.xinitrc
    echo "[+] .xinitrc copied to home directory."
else
    echo "[!] .xinitrc file not found in the script directory!"
fi

# Make sure it's executable
chmod +x ~/.xinitrc

chmod +x ./installTools.sh
chmod +x ./setupPentest_dirs.sh

./installTools.sh
./setupPentest_dirs.sh

# Ask user about reboot
echo -e "${YELLOW}[*] Do you want to reboot now? (y/*]()"
