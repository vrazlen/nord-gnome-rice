#!/usr/bin/env bash
set -euo pipefail

opacity="${1:-0.92}"
profile_uuid="$(dconf read /org/gnome/Ptyxis/default-profile-uuid | tr -d "'")"
if [ -z "$profile_uuid" ]; then
  printf "No default Ptyxis profile UUID found.\n" >&2
  exit 1
fi

dconf write "/org/gnome/Ptyxis/Profiles/${profile_uuid}/opacity" "$opacity"
printf "Set Ptyxis opacity to %s for profile %s.\n" "$opacity" "$profile_uuid"
