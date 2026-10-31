#!/bin/sh
# Keep the hidden panel out of the desktop, including on startup and reload.
set -eu
state=$(cat /proc/acpi/button/lid/*/state)
case "$state" in
  *closed*)
    swaymsg 'output eDP-1 disable'
    if ! swaymsg -t get_outputs | jq -e \
      'any(.[]; .name != "eDP-1" and .active)' >/dev/null; then
      "$HOME/.config/sway/lock.sh"
    fi
    ;;
  *open*) swaymsg 'output eDP-1 enable' ;;
  *) echo "Cannot determine lid state: $state" >&2; exit 1 ;;
esac
