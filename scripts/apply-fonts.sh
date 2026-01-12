#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT_DIR/backup"
gsettings get org.gnome.desktop.interface font-name > "$ROOT_DIR/backup/font-name.txt"
gsettings get org.gnome.desktop.interface document-font-name > "$ROOT_DIR/backup/document-font-name.txt"
gsettings get org.gnome.desktop.interface monospace-font-name > "$ROOT_DIR/backup/monospace-font-name.txt"

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

if ! fc-list | grep -qi "Inter"; then
  printf "Installing Inter font from GitHub...\n"
  INTER_VERSION="4.1"
  INTER_URL="https://github.com/rsms/inter/releases/download/v${INTER_VERSION}/Inter-${INTER_VERSION}.zip"
  TEMP_DIR=$(mktemp -d)
  
  curl -L "$INTER_URL" -o "$TEMP_DIR/Inter.zip"
  unzip -q "$TEMP_DIR/Inter.zip" "InterVariable.ttf" "InterVariable-Italic.ttf" -d "$TEMP_DIR"
  cp "$TEMP_DIR"/InterVariable*.ttf "$FONTS_DIR/"
  rm -rf "$TEMP_DIR"
  
  fc-cache -f
  printf "Installed Inter font (variable font version).\n"
else
  printf "Inter font already available.\n"
fi

if rpm -q jetbrains-mono-fonts &>/dev/null; then
  printf "JetBrains Mono already installed via package.\n"
elif fc-list | grep -q "JetBrains Mono:style=Regular"; then
  printf "JetBrains Mono already available.\n"
else
  printf "Installing JetBrains Mono from GitHub...\n"
  JETBRAINS_VERSION="2.304"
  JETBRAINS_URL="https://github.com/JetBrains/JetBrainsMono/releases/download/v${JETBRAINS_VERSION}/JetBrainsMono-${JETBRAINS_VERSION}.zip"
  TEMP_DIR=$(mktemp -d)
  
  curl -L "$JETBRAINS_URL" -o "$TEMP_DIR/JetBrainsMono.zip"
  unzip -q "$TEMP_DIR/JetBrainsMono.zip" "fonts/ttf/*.ttf" -d "$TEMP_DIR"
  
  find "$TEMP_DIR/fonts/ttf" -name "JetBrainsMono-*.ttf" ! -name "*NL*" -exec cp {} "$FONTS_DIR/" \;
  
  rm -rf "$TEMP_DIR"
  
  fc-cache -f
  printf "Installed JetBrains Mono font (static TTF for terminal compatibility).\n"
fi

gsettings set org.gnome.desktop.interface font-name "Inter 11"
gsettings set org.gnome.desktop.interface document-font-name "Inter 12"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrains Mono 11"

printf "Applied Inter (UI/document) and JetBrains Mono (monospace) fonts.\n"
