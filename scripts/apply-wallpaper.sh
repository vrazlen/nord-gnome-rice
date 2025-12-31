#!/usr/bin/env bash
set -euo pipefail

wall_dir="$HOME/Pictures/Wallpapers/Nordic"
if [ ! -d "$wall_dir/.git" ]; then
  mkdir -p "$HOME/Pictures/Wallpapers"
  git clone https://github.com/linuxdotexe/nordic-wallpapers "$wall_dir"
else
  git -C "$wall_dir" pull --ff-only
fi

wallpaper=$(python - <<'PY'
from pathlib import Path
root = Path.home() / "Pictures/Wallpapers/Nordic/wallpapers"
files = sorted([p for p in root.glob("*") if p.is_file()])
print(files[0] if files else "")
PY
)

if [ -z "$wallpaper" ]; then
  printf "No wallpaper found in %s\n" "$wall_dir" >&2
  exit 1
fi

uri="file://${wallpaper}"
gsettings set org.gnome.desktop.background picture-uri "$uri"
gsettings set org.gnome.desktop.background picture-uri-dark "$uri"

printf "Wallpaper set to %s\n" "$wallpaper"
