#!/bin/sh
# systemd coalesces lock requests and waits for the compositor's locked event.
systemctl --user import-environment WAYLAND_DISPLAY || exit 1
exec systemctl --user start sway-lock.service
