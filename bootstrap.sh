#!/bin/sh
# Fresh-install entry point: installs Ansible, applies the playbook, then
# prompts for the interactive state that can't live in a repo. Safe to re-run.
set -eu
cd "$(dirname "$0")"
sudo dnf install -y ansible
ansible-playbook site.yml "$@"

# Auth token and fingerprint templates: secrets and biometrics, so prompted.
gh auth status >/dev/null 2>&1 || gh auth login --git-protocol https --web
fprintd-list "$USER" 2>/dev/null | grep -q ' - #' || fprintd-enroll
