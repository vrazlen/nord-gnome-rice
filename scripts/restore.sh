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
