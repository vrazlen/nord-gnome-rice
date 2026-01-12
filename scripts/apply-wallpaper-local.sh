#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER_PATH="$ROOT_DIR/apps/wallpapers/custom/at_the_coffeshop.png"

# Validate wallpaper exists
if [ ! -f "$WALLPAPER_PATH" ]; then
  printf "ERROR: Wallpaper not found at %s\n" "$WALLPAPER_PATH" >&2
  exit 1
fi

# Backup current wallpaper settings
mkdir -p "$ROOT_DIR/backup"
gsettings get org.gnome.desktop.background picture-uri > "$ROOT_DIR/backup/wallpaper-picture-uri.txt"
gsettings get org.gnome.desktop.background picture-uri-dark > "$ROOT_DIR/backup/wallpaper-picture-uri-dark.txt"
gsettings get org.gnome.desktop.screensaver picture-uri > "$ROOT_DIR/backup/screensaver-picture-uri.txt"

# Convert to file:// URI
WALLPAPER_URI="file://$(realpath "$WALLPAPER_PATH")"

# Apply wallpaper to user session (background + lock screen)
gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER_URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER_URI"
gsettings set org.gnome.desktop.screensaver picture-uri "$WALLPAPER_URI"

printf "Applied wallpaper to user session (background + lock screen).\n"
