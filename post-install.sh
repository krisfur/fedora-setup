#!/bin/sh
# Run from the desktop once the browser is signed in. Safe to re-run.
# Auth token and fingerprint templates: secrets and biometrics, so prompted.
set -eu
gh auth status >/dev/null 2>&1 || gh auth login --git-protocol https --web
fprintd-list "$USER" 2>/dev/null | grep -q ' - #' || fprintd-enroll
