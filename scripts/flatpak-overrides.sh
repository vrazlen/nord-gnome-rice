#!/usr/bin/env bash
set -euo pipefail

flatpak override --user --filesystem=xdg-config/gtk-4.0
flatpak override --user --filesystem=xdg-config/gtk-3.0
