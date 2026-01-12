#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLPAPER_SRC="$ROOT_DIR/apps/wallpapers/custom/at_the_coffeshop.png"
WALLPAPER_DEST="/usr/share/backgrounds/nord-gnome-rice-at-the-coffeshop.png"
DCONF_PROFILE="/etc/dconf/profile/gdm"
DCONF_KEYFILE="/etc/dconf/db/gdm.d/00-nord-gnome-rice"

# Validate wallpaper exists
if [ ! -f "$WALLPAPER_SRC" ]; then
  printf "ERROR: Wallpaper not found at %s\n" "$WALLPAPER_SRC" >&2
  exit 1
fi

# Backup existing GDM configuration
mkdir -p "$ROOT_DIR/backup"
if [ -f "$DCONF_PROFILE" ]; then
  sudo cp "$DCONF_PROFILE" "$ROOT_DIR/backup/gdm-dconf-profile"
fi
if [ -f "$DCONF_KEYFILE" ]; then
  sudo cp "$DCONF_KEYFILE" "$ROOT_DIR/backup/gdm-dconf-keyfile"
fi

# Copy wallpaper to system location
printf "Copying wallpaper to %s (requires sudo)...\n" "$WALLPAPER_DEST"
sudo cp "$WALLPAPER_SRC" "$WALLPAPER_DEST"
sudo chmod 644 "$WALLPAPER_DEST"

# Create dconf profile if missing
if [ ! -f "$DCONF_PROFILE" ]; then
  printf "Creating GDM dconf profile...\n"
  printf "user-db:user\nsystem-db:gdm\nfile-db:/usr/share/gdm/greeter-dconf-defaults\n" | sudo tee "$DCONF_PROFILE" > /dev/null
fi

# Create dconf keyfile for GDM wallpaper
printf "Configuring GDM wallpaper...\n"
sudo tee "$DCONF_KEYFILE" > /dev/null <<EOF
[org/gnome/desktop/background]
picture-uri='file://$WALLPAPER_DEST'
picture-uri-dark='file://$WALLPAPER_DEST'

[org/gnome/desktop/screensaver]
picture-uri='file://$WALLPAPER_DEST'
EOF

# Update dconf database
sudo dconf update

printf "Applied GDM wallpaper.\n"
printf "NOTE: Changes will take effect after logout/reboot.\n"
