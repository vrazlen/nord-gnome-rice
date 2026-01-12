#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$ROOT_DIR/backup/gtk-4.0.gtk.css" ]; then
  cp "$ROOT_DIR/backup/gtk-4.0.gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
else
  rm -f "$HOME/.config/gtk-4.0/gtk.css"
fi

if [ -f "$ROOT_DIR/backup/gtk-3.0.gtk.css" ]; then
  cp "$ROOT_DIR/backup/gtk-3.0.gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
else
  rm -f "$HOME/.config/gtk-3.0/gtk.css"
fi

printf "Restored GTK overrides (if backups existed).\n"

# Restore icons
if [ -f "$ROOT_DIR/backup/icon-theme.txt" ]; then
  ICON_THEME=$(cat "$ROOT_DIR/backup/icon-theme.txt" | tr -d "'")
  gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
  printf "Restored icon theme: %s\n" "$ICON_THEME"
else
  gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
  printf "Reset icon theme to Fedora default: Adwaita\n"
fi

# Restore cursor
if [ -f "$ROOT_DIR/backup/cursor-theme.txt" ]; then
  CURSOR_THEME=$(cat "$ROOT_DIR/backup/cursor-theme.txt" | tr -d "'")
  gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
  printf "Restored cursor theme: %s\n" "$CURSOR_THEME"
else
  gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
  printf "Reset cursor theme to Fedora default: Adwaita\n"
fi

if [ -f "$ROOT_DIR/backup/cursor-size.txt" ]; then
  CURSOR_SIZE=$(cat "$ROOT_DIR/backup/cursor-size.txt")
  gsettings set org.gnome.desktop.interface cursor-size "$CURSOR_SIZE"
  printf "Restored cursor size: %s\n" "$CURSOR_SIZE"
else
  gsettings set org.gnome.desktop.interface cursor-size 24
  printf "Reset cursor size to default: 24\n"
fi

# Restore fonts
if [ -f "$ROOT_DIR/backup/font-name.txt" ]; then
  FONT_NAME=$(cat "$ROOT_DIR/backup/font-name.txt" | tr -d "'")
  gsettings set org.gnome.desktop.interface font-name "$FONT_NAME"
  printf "Restored font: %s\n" "$FONT_NAME"
else
  gsettings set org.gnome.desktop.interface font-name "Cantarell 11"
  printf "Reset font to Fedora default: Cantarell 11\n"
fi

if [ -f "$ROOT_DIR/backup/document-font-name.txt" ]; then
  DOC_FONT=$(cat "$ROOT_DIR/backup/document-font-name.txt" | tr -d "'")
  gsettings set org.gnome.desktop.interface document-font-name "$DOC_FONT"
  printf "Restored document font: %s\n" "$DOC_FONT"
else
  gsettings set org.gnome.desktop.interface document-font-name "Cantarell 11"
  printf "Reset document font to Fedora default: Cantarell 11\n"
fi

if [ -f "$ROOT_DIR/backup/monospace-font-name.txt" ]; then
  MONO_FONT=$(cat "$ROOT_DIR/backup/monospace-font-name.txt" | tr -d "'")
  gsettings set org.gnome.desktop.interface monospace-font-name "$MONO_FONT"
  printf "Restored monospace font: %s\n" "$MONO_FONT"
else
  gsettings set org.gnome.desktop.interface monospace-font-name "Source Code Pro 10"
  printf "Reset monospace font to Fedora default: Source Code Pro 10\n"
fi

# Restore wallpapers
if [ -f "$ROOT_DIR/backup/wallpaper-picture-uri.txt" ]; then
  WP_URI=$(cat "$ROOT_DIR/backup/wallpaper-picture-uri.txt" | tr -d "'")
  gsettings set org.gnome.desktop.background picture-uri "$WP_URI"
  printf "Restored wallpaper URI: %s\n" "$WP_URI"
fi

if [ -f "$ROOT_DIR/backup/wallpaper-picture-uri-dark.txt" ]; then
  WP_DARK_URI=$(cat "$ROOT_DIR/backup/wallpaper-picture-uri-dark.txt" | tr -d "'")
  gsettings set org.gnome.desktop.background picture-uri-dark "$WP_DARK_URI"
  printf "Restored dark wallpaper URI: %s\n" "$WP_DARK_URI"
fi

if [ -f "$ROOT_DIR/backup/screensaver-picture-uri.txt" ]; then
  SS_URI=$(cat "$ROOT_DIR/backup/screensaver-picture-uri.txt" | tr -d "'")
  gsettings set org.gnome.desktop.screensaver picture-uri "$SS_URI"
  printf "Restored screensaver URI: %s\n" "$SS_URI"
fi

# Restore GDM wallpaper (requires sudo)
if [ -f "$ROOT_DIR/backup/gdm-dconf-profile" ] || [ -f "$ROOT_DIR/backup/gdm-dconf-keyfile" ]; then
  printf "\n=== GDM wallpaper restore (requires sudo) ===\n"
  if [ -f "$ROOT_DIR/backup/gdm-dconf-profile" ]; then
    sudo cp "$ROOT_DIR/backup/gdm-dconf-profile" /etc/dconf/profile/gdm
    printf "Restored /etc/dconf/profile/gdm\n"
  else
    sudo rm -f /etc/dconf/profile/gdm
    printf "Removed /etc/dconf/profile/gdm (did not exist before)\n"
  fi
  
  if [ -f "$ROOT_DIR/backup/gdm-dconf-keyfile" ]; then
    sudo cp "$ROOT_DIR/backup/gdm-dconf-keyfile" /etc/dconf/db/gdm.d/00-nord-gnome-rice
    printf "Restored /etc/dconf/db/gdm.d/00-nord-gnome-rice\n"
  else
    sudo rm -f /etc/dconf/db/gdm.d/00-nord-gnome-rice
    printf "Removed /etc/dconf/db/gdm.d/00-nord-gnome-rice (did not exist before)\n"
  fi
  
  sudo dconf update
  printf "Updated dconf database.\n"
fi

# Restore Plymouth theme (requires sudo)
if [ -f "$ROOT_DIR/backup/plymouth-theme.txt" ]; then
  PLYMOUTH_THEME=$(cat "$ROOT_DIR/backup/plymouth-theme.txt" | tr -d "'" | xargs)
  printf "\n=== Plymouth theme restore (requires sudo) ===\n"
  printf "Restoring Plymouth theme: %s\n" "$PLYMOUTH_THEME"
  sudo plymouth-set-default-theme -R "$PLYMOUTH_THEME"
  printf "Restored Plymouth theme and rebuilt initramfs.\n"
fi

printf "\nRestore complete.\n"
