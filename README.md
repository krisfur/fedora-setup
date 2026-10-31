# Fedora setup

Ansible playbook for a minimal Fedora install with Sway, greetd, Waybar, Ghostty, and the Dust palette. Ported from [nixos-setup](https://github.com/krisfur/nixos-setup).

![screenshot](./screenshot.png)

## Install

1. Boot the Fedora Everything netinstall ISO and choose **Minimal Install**. Create the user `kfurman` with administrator rights and keep the default btrfs layout.
2. After first boot, log in on the TTY and run:

```sh
sudo dnf install -y git
git clone https://github.com/krisfur/fedora-setup ~/code/fedora-setup
~/code/fedora-setup/bootstrap.sh
```

`bootstrap.sh` ends by prompting for `gh auth login` and fingerprint enrolment, the only state that can't live in the repo (an auth token and biometric templates). Both are skipped on re-runs once done.

3. Reboot. greetd starts on tty1.

The repo must stay at the path it was cloned to: files under `home/` are symlinked into `$HOME`, so moving the checkout breaks them.

## Apply changes later

```sh
ansible-playbook site.yml --check --diff   # preview
ansible-playbook site.yml                  # apply
ansible-playbook site.yml --tags user      # one role: repos, base, desktop, dev, apps, user
ansible-playbook site.yml --tags upstream  # update apps that have no repository
```

Dotfiles are symlinks, so edits under `home/` take effect without a run. Re-run only for packages, files in `/etc`, or new files under `home/`.

## Layout

| Path | Responsibility |
| --- | --- |
| `site.yml` | System play (root) and user play. |
| `group_vars/all.yml` | Username and pinned upstream downloads. |
| `roles/repos` | RPM Fusion and COPRs (restricted with `includepkgs`). |
| `roles/base` | Kernel arguments, firewall, locale, power profiles, wifi, zram, sysctl, and snapper. |
| `roles/desktop` | Sway session, greetd, PipeWire with speaker DSP plugins, portals, fingerprint, and Thunar. |
| `roles/dev` | Toolchains, language servers, Docker, and uinput. |
| `roles/apps` | Desktop applications, codecs, Proton Authenticator, and controller udev rules. |
| `roles/user` | Symlinks `home/` into `$HOME`, plus fonts, cursor, folder colours, dconf, default browser, Claude Code, Neovim, mise, AppImages, and GE-Proton. |
| `home/` | Dotfiles, mirroring `$HOME`. |

## Package sources

1. Fedora repos.
2. RPM Fusion for Steam, Discord, and full codecs.
3. Upstream-run COPRs: `imput/helium` and `jdxcode/mise`.
4. Third-party COPRs: `scottames/ghostty` and `sdegler/hyprland` (hyprlock only).
5. Upstream releases, verified by checksum and updated by `--tags upstream`: Proton Authenticator (RPM), LocalSend and RPCS3 (AppImages), and GE-Proton.
6. mise (`home/.config/mise/config.toml`) for dev tools Fedora lacks.

Anything installed with `dnf` by hand is not tracked here, so compare `dnf repoquery --userinstalled` against the playbook occasionally.

## Snapshots

On btrfs, snapper snapshots `/` before and after every dnf transaction (10 kept, no hourly timeline). `/home` is a separate subvolume and is never rolled back.

```sh
snapper list                    # find the transaction's pre snapshot
sudo snapper undochange 41..0   # revert / to that snapshot
```

Use `<pre>..0`, not `<pre>..<post>`: the rpm database is flushed after the post snapshot, so a pre..post undo restores files but leaves rpm thinking the package is still installed. `..0` also reverts any later changes to `/`, so use it for the most recent transaction.

Booting into a snapshot is not set up; if an update breaks boot, pick the previous kernel in the GRUB menu.
