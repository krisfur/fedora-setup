#!/bin/sh
# Run from the desktop once the browser is signed in. Safe to re-run.
# Auth token and fingerprint templates: secrets and biometrics, so prompted.
set -eu
gh auth status >/dev/null 2>&1 || gh auth login --git-protocol https --web
fingers=$(fprintd-list "$USER" 2>/dev/null) || true
case $fingers in
  *"No devices available"*) echo "No supported fingerprint reader, skipping enrolment." ;;
  *" - #"*) ;;
  *) fprintd-enroll ;;
esac
