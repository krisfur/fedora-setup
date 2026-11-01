#!/bin/sh
# Installs Ansible and applies the playbook. Safe to re-run. The ISO's first-boot
# service does this itself, so this is for applying changes by hand.
set -eu
cd "$(dirname "$0")"
sudo dnf install -y ansible
ansible-playbook site.yml "$@"
