# nord-gnome-rice

Minimal Nord ricing setup for Fedora 43 GNOME Wayland with GTK, GNOME Shell, and app theming scripts.

## Requirements

- Fedora 43 GNOME Wayland
- git, curl, python, tar, wget
- flatpak (for Discord/Spotify/Telegram Flatpaks)
- spicetify (installed by script if missing)
- sudo access (for GDM and Plymouth theming only)

## Scripts

### Core Theme Scripts

- `scripts/apply.sh`: Apply full Nord theme (GTK, icons, cursor, fonts, wallpaper, dconf settings)
- `scripts/restore.sh`: Restore previous settings from backup or reset to Fedora defaults

### System Theming (Included in apply.sh)

- `scripts/apply-icons.sh`: Install Papirus-Dark icon theme
- `scripts/apply-cursor.sh`: Install Bibata-Modern-Ice cursor theme (size 24)
- `scripts/apply-fonts.sh`: Install Inter UI font and JetBrains Mono monospace font
- `scripts/apply-wallpaper-local.sh`: Set local wallpaper for desktop and lock screen

### System-Level Theming (Requires sudo, run separately)

- `scripts/apply-gdm-wallpaper.sh`: Apply wallpaper to GDM login screen (**Note: May not work on all systems**)
- `scripts/apply-plymouth-nord-tint.sh`: Apply Nord-tinted Plymouth boot theme (**Note: May not work on all systems**)

### Application-Specific Theming

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

## Wallpaper Setup

The default `apply.sh` uses a local wallpaper at `apps/wallpapers/custom/at_the_coffeshop.png`. 

**To use your own wallpaper:**
1. Copy your wallpaper to `apps/wallpapers/custom/` (this directory is gitignored)
2. Edit `scripts/apply-wallpaper-local.sh` and update the `WALLPAPER_PATH` variable
3. Run `./scripts/apply.sh` or `./scripts/apply-wallpaper-local.sh` directly

Alternatively, use `scripts/apply-wallpaper.sh` to download the full Nordic wallpaper collection.

## Known Issues

- **GDM Wallpaper**: May not apply correctly on some Fedora 43 systems due to GDM dconf handling variations
- **Plymouth Theme**: May not display correctly on some systems; requires reboot to test
- **Font Downloads**: Inter and JetBrains Mono are downloaded directly from GitHub (not available in Fedora repos)
- **Cursor Theme**: Bibata-Modern-Ice is downloaded directly from GitHub (COPR repo doesn't have the package)

If GDM or Plymouth theming fails, you can safely skip those scripts - the rest of the theme will still work perfectly.
