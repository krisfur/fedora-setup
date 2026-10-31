#!/usr/bin/env bash
# ExecStart of sway-lock.service. hyprlock, not swaylock: it waits on password
# and fingerprint concurrently, which swaylock can't (it collects input first,
# then runs PAM).
#
# Hyprlock lacks a readiness fd; this message is emitted by its locked callback.
# Do not use SIGUSR2 during startup: its handler may not yet be installed.
set -uo pipefail
ready=$(mktemp)
trap 'rm -f "$ready"' EXIT
hyprlock --grace 0 --no-fade-in 2>&1 | while IFS= read -r line; do
  printf '%s\n' "$line"
  case "$line" in
    *"]: onLockLocked called"|*"[LOG] onLockLocked called")
      systemd-notify --ready && printf 'ready\n' > "$ready"
      ;;
  esac
done
status=$?
# Only the locker that acquired the session may reset its fingerprint claim.
if [ "$status" -eq 0 ] && [ -s "$ready" ]; then
  systemctl restart fprintd.service || true
fi
exit "$status"
