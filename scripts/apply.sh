#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT_DIR/backup"
if [ -f "$HOME/.config/gtk-4.0/gtk.css" ]; then
  cp "$HOME/.config/gtk-4.0/gtk.css" "$ROOT_DIR/backup/gtk-4.0.gtk.css"
fi
if [ -f "$HOME/.config/gtk-3.0/gtk.css" ]; then
  cp "$HOME/.config/gtk-3.0/gtk.css" "$ROOT_DIR/backup/gtk-3.0.gtk.css"
fi

mkdir -p "$HOME/.config/gtk-4.0" "$HOME/.config/gtk-3.0"
cp "$ROOT_DIR/gtk/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
cp "$ROOT_DIR/gtk/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"

gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

if [ -f "$ROOT_DIR/dconf/gnome-terminal.dconf" ]; then
  dconf load /org/gnome/terminal/ < "$ROOT_DIR/dconf/gnome-terminal.dconf"
fi
if [ -f "$ROOT_DIR/dconf/gnome-console.dconf" ]; then
  dconf load /org/gnome/console/ < "$ROOT_DIR/dconf/gnome-console.dconf"
fi
if [ -f "$ROOT_DIR/dconf/ptyxis.dconf" ]; then
  dconf load /org/gnome/Ptyxis/ < "$ROOT_DIR/dconf/ptyxis.dconf"
fi
if [ -f "$ROOT_DIR/dconf/blur-my-shell.dconf" ]; then
  dconf load /org/gnome/shell/extensions/blur-my-shell/ < "$ROOT_DIR/dconf/blur-my-shell.dconf"
fi
if [ -f "$ROOT_DIR/dconf/rounded-window-corners-reborn.dconf" ]; then
  dconf load /org/gnome/shell/extensions/rounded-window-corners-reborn/ < "$ROOT_DIR/dconf/rounded-window-corners-reborn.dconf"
fi
if [ -f "$ROOT_DIR/dconf/user-theme.dconf" ]; then
  dconf load /org/gnome/shell/extensions/user-theme/ < "$ROOT_DIR/dconf/user-theme.dconf"
fi

printf "Applied Nord GTK overrides.\n"

# Apply additional Nord customizations
if [ -f "$ROOT_DIR/scripts/apply-icons.sh" ]; then
  bash "$ROOT_DIR/scripts/apply-icons.sh"
fi

if [ -f "$ROOT_DIR/scripts/apply-cursor.sh" ]; then
  bash "$ROOT_DIR/scripts/apply-cursor.sh"
fi

if [ -f "$ROOT_DIR/scripts/apply-fonts.sh" ]; then
  bash "$ROOT_DIR/scripts/apply-fonts.sh"
fi

if [ -f "$ROOT_DIR/scripts/apply-wallpaper-local.sh" ]; then
  bash "$ROOT_DIR/scripts/apply-wallpaper-local.sh"
fi

printf "\n=== Optional system-level theming (requires sudo) ===\n"
printf "To apply GDM wallpaper: bash %s/scripts/apply-gdm-wallpaper.sh\n" "$ROOT_DIR"
printf "To apply Plymouth Nord theme: bash %s/scripts/apply-plymouth-nord-tint.sh\n" "$ROOT_DIR"
