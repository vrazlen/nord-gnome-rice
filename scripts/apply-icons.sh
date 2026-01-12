#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Backup current icon theme setting
mkdir -p "$ROOT_DIR/backup"
gsettings get org.gnome.desktop.interface icon-theme > "$ROOT_DIR/backup/icon-theme.txt"

# Install Papirus icon theme (includes Papirus-Dark)
if ! rpm -q papirus-icon-theme &>/dev/null; then
  printf "Installing Papirus icon theme...\n"
  sudo dnf install -y papirus-icon-theme
else
  printf "Papirus icon theme already installed.\n"
fi

# Apply Papirus-Dark
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

printf "Applied Papirus-Dark icon theme.\n"
