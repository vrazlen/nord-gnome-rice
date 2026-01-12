#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT_DIR/backup"
gsettings get org.gnome.desktop.interface cursor-theme > "$ROOT_DIR/backup/cursor-theme.txt"
gsettings get org.gnome.desktop.interface cursor-size > "$ROOT_DIR/backup/cursor-size.txt"

CURSOR_INSTALLED=false

if dnf copr list --enabled 2>/dev/null | grep -q "peterwu/rendezvous"; then
  if rpm -q bibata-cursor-theme &>/dev/null; then
    CURSOR_INSTALLED=true
  fi
else
  printf "COPR repository approach unavailable. Using direct download from GitHub...\n"
fi

if ! $CURSOR_INSTALLED; then
  INSTALL_DIR="$HOME/.local/share/icons"
  mkdir -p "$INSTALL_DIR"
  
  if [ -d "$INSTALL_DIR/Bibata-Modern-Ice" ]; then
    printf "Bibata-Modern-Ice already installed in %s\n" "$INSTALL_DIR"
  else
    DOWNLOAD_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"
    TEMP_DIR=$(mktemp -d)
    
    printf "Downloading Bibata-Modern-Ice from GitHub...\n"
    curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/Bibata-Modern-Ice.tar.xz"
    
    printf "Extracting to %s...\n" "$INSTALL_DIR"
    tar -xf "$TEMP_DIR/Bibata-Modern-Ice.tar.xz" -C "$INSTALL_DIR"
    
    rm -rf "$TEMP_DIR"
    printf "Installed Bibata-Modern-Ice cursor theme.\n"
  fi
fi

gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface cursor-size 24

printf "Applied Bibata-Modern-Ice cursor theme (size 24).\n"
