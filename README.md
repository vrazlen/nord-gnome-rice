# nord-gnome-rice

Minimal Nord ricing setup for Fedora 43 GNOME Wayland with GTK, GNOME Shell, and app theming scripts.

## Requirements

- Fedora 43 GNOME Wayland
- git, curl, python
- flatpak (for Discord/Spotify/Telegram Flatpaks)
- spicetify (installed by script if missing)

## Scripts

- `scripts/apply.sh`: Apply GTK and dconf settings
- `scripts/restore.sh`: Restore previous settings
- `scripts/apply-firefox.sh`: Install Firefox GNOME theme and Nord theme XPI
- `scripts/apply-telegram.sh`: Download Nord Telegram theme
- `scripts/apply-spotify.sh`: Apply Spicetify Sleek + Nord
- `scripts/apply-discord.sh`: Install Nord CSS for Vencord
- `scripts/apply-wallpaper.sh`: Install Nordic wallpapers and set one

## App setup

### Firefox

1. Run `scripts/apply-firefox.sh`
2. Restart Firefox
3. Ensure the Nord theme is enabled in `about:addons` if needed

### Telegram

1. Run `scripts/apply-telegram.sh`
2. Import `~/.var/app/org.telegram.desktop/data/nord.tdesktop-theme` in Telegram settings
   - One-click: https://t.me/addtheme/kde_nordic

### Spotify

1. Run `scripts/apply-spotify.sh`
2. If prompted, run `spicetify restore backup` then `spicetify backup apply`
3. Restart Spotify

### Discord (Vencord)

Recommended: install Discord as a user Flatpak to allow patching.

1. Install user Discord Flatpak:
   - `flatpak --user install flathub com.discordapp.Discord`
2. Run the Vencord installer and patch Discord
3. Run `scripts/apply-discord.sh`
4. Open Discord -> Vencord -> Themes and enable `Nord.css`

Flatpak Vencord themes are read from:
`~/.var/app/com.discordapp.Discord/config/Vencord/themes`
