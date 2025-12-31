#!/usr/bin/env bash
set -euo pipefail

src="https://raw.githubusercontent.com/YazdanZ/Telegram-Nordic/master/colors.tdesktop-theme"
dest="$HOME/.var/app/org.telegram.desktop/data/nord.tdesktop-theme"
mkdir -p "$(dirname "$dest")"
curl -fsSL -o "$dest" "$src"

printf "Telegram theme downloaded to %s. Import it in Telegram Settings.\n" "$dest"
printf "One-click alternative: https://t.me/addtheme/kde_nordic\n"
