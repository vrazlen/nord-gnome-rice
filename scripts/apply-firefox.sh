#!/usr/bin/env bash
set -euo pipefail

profile_dir=$(python - <<'PY'
import configparser
from pathlib import Path
ini = Path.home() / ".mozilla/firefox/profiles.ini"
config = configparser.RawConfigParser()
config.read(ini)
profiles = []
for section in config.sections():
    if section.startswith("Profile"):
        path = config.get(section, "Path", fallback="")
        default = config.get(section, "Default", fallback="0")
        if path:
            profiles.append((default == "1", path))
profiles.sort(reverse=True)
if profiles:
    print(str(Path.home() / ".mozilla/firefox" / profiles[0][1]))
PY
)

if [ -z "$profile_dir" ] || [ ! -d "$profile_dir" ]; then
  printf "Firefox profile not found.\n" >&2
  exit 1
fi

mkdir -p "$profile_dir/chrome"
if [ ! -d "$profile_dir/chrome/firefox-gnome-theme" ]; then
  git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git "$profile_dir/chrome/firefox-gnome-theme"
else
  git -C "$profile_dir/chrome/firefox-gnome-theme" pull --ff-only
fi

for file in userChrome.css userContent.css; do
  if [ ! -s "$profile_dir/chrome/$file" ]; then
    printf "\n" >> "$profile_dir/chrome/$file"
  fi
  if ! rg -q "firefox-gnome-theme/${file}" "$profile_dir/chrome/$file"; then
    sed -i "1s#^#@import \"firefox-gnome-theme/${file}\";\n#" "$profile_dir/chrome/$file"
  fi
done

ln -fs chrome/firefox-gnome-theme/configuration/user.js "$profile_dir/user.js"

xpi_url="https://addons.mozilla.org/firefox/downloads/file/3849722/nord_firefox-2.41.xpi"
guid="{f4c9e1d6-6630-4600-ad50-d223eab7f3e7}"
mkdir -p "$profile_dir/extensions"
curl -fsSL -o "$profile_dir/extensions/${guid}.xpi" "$xpi_url"

printf "Firefox GNOME theme installed and Nord theme XPI placed. Restart Firefox.\n"
