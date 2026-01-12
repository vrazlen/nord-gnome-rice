#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_NAME="nord-spinner"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"

# Backup current Plymouth theme
mkdir -p "$ROOT_DIR/backup"
plymouth-set-default-theme 2>/dev/null | sudo tee "$ROOT_DIR/backup/plymouth-theme.txt" > /dev/null || echo "spinner" | sudo tee "$ROOT_DIR/backup/plymouth-theme.txt" > /dev/null

# Backup current initramfs
KERNEL_VERSION="$(uname -r)"
INITRAMFS_PATH="/boot/initramfs-${KERNEL_VERSION}.img"
if [ -f "$INITRAMFS_PATH" ]; then
  printf "Backing up initramfs (this may take a moment)...\n"
  sudo cp "$INITRAMFS_PATH" "$ROOT_DIR/backup/initramfs-${KERNEL_VERSION}.img.bak"
fi

# Create Nord spinner theme directory
printf "Creating Nord Plymouth theme (requires sudo)...\n"
sudo mkdir -p "$THEME_DIR"

# Create spinner theme with Nord colors
# Nord Polar Night #2E3440 (background), Nord Frost #88C0D0 (spinner)
sudo tee "$THEME_DIR/${THEME_NAME}.plymouth" > /dev/null <<'EOF'
[Plymouth Theme]
Name=Nord Spinner
Description=Fedora spinner with Nord color palette
ModuleName=two-step

[two-step]
BackgroundStartColor=0x2E3440
BackgroundEndColor=0x2E3440
ProgressBarBackgroundColor=0x3B4252
ProgressBarForegroundColor=0x88C0D0
MessageBelowAnimation=true
EOF

# Create script symlink (required by Plymouth)
if [ -f "/usr/share/plymouth/themes/spinner/two-step.script" ]; then
  sudo ln -sf /usr/share/plymouth/themes/spinner/two-step.script "$THEME_DIR/two-step.script"
elif [ -f "/usr/share/plymouth/themes/bgrt/bgrt.script" ]; then
  # Fallback to bgrt script if spinner missing
  sudo ln -sf /usr/share/plymouth/themes/bgrt/bgrt.script "$THEME_DIR/two-step.script"
fi

# Copy watermark assets if available (optional)
if [ -d "/usr/share/plymouth/themes/spinner" ]; then
  sudo cp -r /usr/share/plymouth/themes/spinner/watermark.png "$THEME_DIR/" 2>/dev/null || true
fi

# Set as default theme and rebuild initramfs
printf "Setting Nord Plymouth theme and rebuilding initramfs (this will take a moment)...\n"
sudo plymouth-set-default-theme -R "$THEME_NAME"

printf "Applied Nord Plymouth theme.\n"
printf "NOTE: Reboot to see changes during boot.\n"
printf "\nRollback instructions (if boot fails):\n"
printf "  1. At GRUB menu, press 'e' to edit boot entry\n"
printf "  2. Find line starting with 'linux' and add: plymouth.ignore-serial-consoles\n"
printf "  3. Press Ctrl+X to boot\n"
printf "  4. Run: sudo plymouth-set-default-theme -R spinner\n"
