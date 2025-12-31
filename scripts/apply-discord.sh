#!/usr/bin/env bash
set -euo pipefail

css_url="https://raw.githubusercontent.com/nautilor/discord-nord-css/8945d3ce4431fb9d4da6b87b84521ed9801f9d36/custom.css"
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
repo_copy="$repo_root/apps/discord/nord.css"
mkdir -p "$(dirname "$repo_copy")"
curl -fsSL -o "$repo_copy" "$css_url"

flatpak_vencord_dir="$HOME/.var/app/com.discordapp.Discord/config/Vencord/themes"
if [ -d "$HOME/.var/app/com.discordapp.Discord" ]; then
  vencord_dir="$flatpak_vencord_dir"
else
  vencord_dir="$HOME/.config/Vencord/themes"
fi
mkdir -p "$vencord_dir"
cp "$repo_copy" "$vencord_dir/Nord.css"

printf "Nord CSS copied to %s. Enable it in Vencord Themes.\n" "$vencord_dir/Nord.css"
