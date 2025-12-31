#!/usr/bin/env bash
set -euo pipefail

if ! command -v spicetify >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
fi

install_root=$(flatpak info --show-location com.spotify.Client)
export install_root
spotify_path=$(python - <<'PY'
from pathlib import Path
import os
root = Path(os.environ['install_root'])
candidates = [
    root / 'active' / 'files' / 'extra' / 'share' / 'spotify',
    root / 'files' / 'extra' / 'share' / 'spotify',
]
for c in candidates:
    if c.is_dir():
        print(str(c))
        raise SystemExit(0)
print('')
PY
)
prefs_path="$HOME/.var/app/com.spotify.Client/config/spotify/prefs"

if [ -z "$spotify_path" ] || [ ! -d "$spotify_path" ]; then
  printf "Spotify path not found.\n" >&2
  exit 1
fi

spicetify config spotify_path "$spotify_path"
spicetify config prefs_path "$prefs_path"

if [ ! -w "$spotify_path" ]; then
  printf "Spotify path not writable: %s\n" "$spotify_path" >&2
  printf "Follow spicetify Flatpak docs and grant write access before retrying.\n" >&2
  exit 1
fi

themes_root="$HOME/.config/spicetify/Themes"
export themes_root
mkdir -p "$themes_root"
if [ -d "$themes_root/.git" ]; then
  git -C "$themes_root" pull --ff-only
elif [ "$(python - <<'PY'
from pathlib import Path
import os
root = Path(os.environ['themes_root'])
print('empty' if not any(root.iterdir()) else '')
PY
)" = "empty" ]; then
  git clone --depth 1 https://github.com/spicetify/spicetify-themes.git "$themes_root"
else
  if [ ! -d "$themes_root/spicetify-themes" ]; then
    git clone --depth 1 https://github.com/spicetify/spicetify-themes.git "$themes_root/spicetify-themes"
  else
    git -C "$themes_root/spicetify-themes" pull --ff-only
  fi
  if [ ! -d "$themes_root/Sleek" ]; then
    cp -R "$themes_root/spicetify-themes/Sleek" "$themes_root/Sleek"
  fi
fi

spicetify config current_theme Sleek
spicetify config color_scheme Nord
spicetify backup apply

printf "Spicetify Nord applied. Restart Spotify.\n"
