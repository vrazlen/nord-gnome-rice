# PROJECT KNOWLEDGE BASE

**Generated:** $(date '+%Y-%m-%d %H:%M %Z')  
**Commit:** $(git rev-parse --short HEAD)  
**Branch:** $(git branch --show-current)

## OVERVIEW

GNOME Nord theme installer for Fedora 43 Wayland. Comprehensive theming system covering GTK, icons, cursor, fonts, wallpapers, GDM, Plymouth, and application-specific customizations.

## STRUCTURE

```
nord-gnome-rice/
├── scripts/            # Main entry points and theming modules
│   ├── apply.sh                      # Master script (GTK + icons + cursor + fonts + wallpaper)
│   ├── restore.sh                    # Full rollback to backups or Fedora defaults
│   ├── apply-icons.sh                # Papirus-Dark icon theme
│   ├── apply-cursor.sh               # Bibata-Modern-Ice cursor (GitHub direct download)
│   ├── apply-fonts.sh                # Inter UI + JetBrains Mono (GitHub direct download)
│   ├── apply-wallpaper-local.sh      # Local wallpaper (desktop + lock screen)
│   ├── apply-gdm-wallpaper.sh        # GDM login screen wallpaper (sudo required)
│   ├── apply-plymouth-nord-tint.sh   # Nord boot theme (sudo required)
│   ├── apply-firefox.sh              # Firefox GNOME + Nord theme
│   ├── apply-telegram.sh             # Telegram Nord theme
│   ├── apply-spotify.sh              # Spicetify Sleek + Nord
│   ├── apply-discord.sh              # Discord Nord CSS (Vencord)
│   └── apply-wallpaper.sh            # Nordic wallpapers collection
├── gtk/                # GTK CSS overrides (gtk-3.0/gtk-4.0)
├── dconf/              # GNOME extension configs (blur-my-shell, rounded-corners, user-theme)
├── apps/               # Per-app theme assets
│   ├── wallpapers/
│   │   └── custom/     # Local wallpapers (gitignored)
│   └── sources.json    # Upstream theme URLs
├── extensions/         # Required GNOME extensions list
├── terminal/           # Nord.palette for terminal emulators
└── backup/             # Runtime backups (gitignored, created by apply.sh)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Apply full theme | `scripts/apply.sh` | Runs GTK + icons + cursor + fonts + wallpaper + dconf |
| Rollback | `scripts/restore.sh` | Restores from `backup/` or resets to Fedora defaults |
| Icons | `scripts/apply-icons.sh` | Installs Papirus-Dark via dnf |
| Cursor | `scripts/apply-cursor.sh` | Downloads Bibata-Modern-Ice v2.0.7 from GitHub |
| Fonts | `scripts/apply-fonts.sh` | Downloads Inter v4.1 + JetBrains Mono v2.304 from GitHub |
| User wallpaper | `scripts/apply-wallpaper-local.sh` | Sets local wallpaper for desktop + lock screen |
| GDM wallpaper | `scripts/apply-gdm-wallpaper.sh` | Requires sudo, may not work on all systems |
| Plymouth theme | `scripts/apply-plymouth-nord-tint.sh` | Requires sudo, may not work on all systems |
| Firefox theming | `scripts/apply-firefox.sh` | Clones firefox-gnome-theme, downloads Nord XPI |
| Telegram theming | `scripts/apply-telegram.sh` | Downloads .tdesktop-theme to Flatpak data dir |
| Spotify theming | `scripts/apply-spotify.sh` | Installs spicetify, applies Sleek + Nord |
| Discord theming | `scripts/apply-discord.sh` | Downloads Nord CSS for Vencord |
| Nordic wallpapers | `scripts/apply-wallpaper.sh` | Clones nordic-wallpapers collection |
| GTK overrides | `gtk/gtk-{3,4}.0/gtk.css` | Nord color vars applied to GTK apps |
| Extension configs | `dconf/*.dconf` | Settings for blur-my-shell, rounded-corners, user-theme |
| Theme URLs | `apps/sources.json` | Upstream repos/direct download links |
| Required extensions | `extensions/extensions.txt` | blur-my-shell, rounded-window-corners-reborn |
| Terminal palette | `terminal/Nord.palette` | Import into GNOME Terminal/Console/Ptyxis |

## CONVENTIONS

**Shell scripts (strict mode)**:
- `#!/usr/bin/env bash` + `set -euo pipefail` (mandatory)
- `ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"` pattern for repo root
- `printf` (not `echo`)
- Explicit `[ -f ... ]` checks before loading dconf/copying files
- Backup to `$ROOT_DIR/backup/` before destructive ops
- Functions for reusability (e.g., `backup_gsetting`, `download_and_extract`)

**Tools used**: `rg`, `sed`, `curl`, `git`, `python` (inline for path discovery), `dconf`, `gsettings`, `tar`, `wget`, `dnf`, `plymouth-set-default-theme`, `dracut`

**Download strategy**: 
- Package manager first (Papirus icons via dnf)
- GitHub direct download as fallback (Inter/JetBrains Mono/Bibata cursor)
- No COPR repos (bibata-cursor-theme package doesn't exist in peterwu/rendezvous)

**No dev tooling**: No package.json, pyproject.toml, Makefile, linters, formatters, CI

## ANTI-PATTERNS (THIS PROJECT)

- **Don't** use `echo` (use `printf`)
- **Don't** skip backups before overwriting user configs
- **Don't** hardcode paths (use `$ROOT_DIR` + `$HOME`)
- **Don't** install variable fonts for monospace (breaks terminal rendering)
- **Don't** trust COPR repos without verification (packages may not exist)

## UNIQUE STYLES

**Flatpak-first**: Scripts target `~/.var/app/{org.telegram.desktop,com.discordapp.Discord}` for Flatpak apps  
**Network-dependent**: Most app scripts download assets at runtime (not bundled)  
**Backup strategy**: Local `backup/` dir (not `$HOME/.config` backups), gitignored  
**Embedded Python**: Used in scripts for Firefox profile path discovery  
**Extension dependency**: Requires manual install of blur-my-shell + rounded-window-corners-reborn  
**GitHub fallbacks**: Direct releases download when Fedora repos lack packages  
**Sudo transparency**: GDM/Plymouth scripts warn before requiring sudo, include rollback safety

## COMMANDS

```bash
# Apply full Nord theme (GTK + icons + cursor + fonts + wallpaper + dconf)
./scripts/apply.sh

# Apply GDM and Plymouth (requires sudo, may not work on all systems)
./scripts/apply-gdm-wallpaper.sh       # Requires logout to see changes
./scripts/apply-plymouth-nord-tint.sh  # Requires reboot to see changes

# Restore previous settings
./scripts/restore.sh

# Per-app theming (run individually)
./scripts/apply-firefox.sh
./scripts/apply-telegram.sh
./scripts/apply-spotify.sh
./scripts/apply-discord.sh
./scripts/apply-wallpaper.sh           # Nordic wallpapers collection

# Set Flatpak permissions (if needed)
./scripts/flatpak-overrides.sh

# Set Ptyxis opacity
./scripts/ptyxis-opacity.sh
```

## KNOWN ISSUES

- **GDM wallpaper**: May not apply correctly on some Fedora 43 systems (dconf handling variations)
- **Plymouth theme**: May not display correctly on some systems (requires reboot to verify)
- **COPR repos**: `peterwu/rendezvous` doesn't have `bibata-cursor-theme` package (use GitHub fallback)
- **Font packages**: `inter-fonts` and `jetbrains-mono-fonts` not in Fedora 43 repos (use GitHub fallback)
- **JetBrains Mono**: Only static TTF files installed (excludes `*NL*` variants to prevent spacing issues)

## NOTES

- **Firefox**: Requires manual theme activation in `about:addons` after script run
- **Telegram**: One-click theme: https://t.me/addtheme/kde_nordic (bypasses script)
- **Spotify**: May require `spicetify restore backup && spicetify backup apply` if prompted
- **Discord**: Requires Vencord pre-installed, enable `Nord.css` in Vencord UI
- **Extensions**: Install blur-my-shell + rounded-window-corners-reborn manually first
- **Terminal palette**: Import `terminal/Nord.palette` manually in terminal settings
- **Backup dir**: Created at runtime by `apply.sh`, not in git
- **Local wallpapers**: `apps/wallpapers/custom/` is gitignored for user privacy
- **Cursor theme**: Downloads Bibata-Modern-Ice v2.0.7 (tar.xz) to `~/.local/share/icons/`
- **Font downloads**: Inter Variable v4.1 + JetBrains Mono Static v2.304 to `~/.local/share/fonts/`
