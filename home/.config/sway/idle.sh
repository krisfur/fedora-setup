#!/bin/sh
# swayidle actions: idle.sh {lock|displays|suspend}. Each is skipped while busy.
#
# Controller input never reaches the seat, so swayidle counts a gamepad
# session or call as idle. Steam's reaper marks a running game, emulators only
# open audio once a game boots, and Discord only captures the mic in a call.
# Media playback holds the Wayland idle inhibitor, which blocks swayidle already.
busy() {
  pgrep -f 'SteamLaunch AppId=' >/dev/null && return 0
  pw-dump | jq -e 'any(.[];
    (.info.props? // {}) as $p
    | ($p."application.process.binary" // "" | ascii_downcase) as $b
    | ($p."media.class" == "Stream/Input/Audio" and ($b | contains("discord")))
      or ($p."media.class" == "Stream/Output/Audio" and ($b | test("dolphin-emu|rpcs3"))))' >/dev/null
}

busy && exit 0
case "$1" in
  lock) exec "$HOME/.config/sway/lock.sh" ;;
  displays) exec swaymsg 'output * power off' ;;
  suspend) exec systemctl --no-block suspend ;;
  *) echo "usage: $0 {lock|displays|suspend}" >&2; exit 2 ;;
esac
