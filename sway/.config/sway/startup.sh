#!/usr/bin/env bash

# RIGHT  — always the integrated display (eDP-*)
# LEFT_VERTICAL / CENTER — external displays; lower port index = left
RIGHT=$(swaymsg -t get_outputs | jq -r 'first(.[] | select(.name | startswith("eDP")) | .name)')
mapfile -t _EXT < <(swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("eDP") | not) | .name' | sort)
LEFT_VERTICAL=${_EXT[0]}
CENTER=${_EXT[1]}

swaymsg "output $LEFT_VERTICAL position 0 0"
swaymsg "output $CENTER resolution 2560x1440 position 1440 741"
swaymsg "output $RIGHT resolution 3840x2400 scale 2 position 4000 1388"
swaymsg "workspace 1 output $LEFT_VERTICAL"
swaymsg "workspace 2 output $CENTER"
swaymsg "workspace 3 output $RIGHT"

wait_for_app() {
    local search="$1"
    for i in $(seq 1 60); do
        swaymsg -t get_tree 2>/dev/null | grep -q "$search" && return 0
        sleep 0.5
    done
    return 1
}

# Export Wayland env to systemd so xdg-desktop-portal-wlr can connect.
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
# Pre-start portal in background so it's ready before waybar needs it.
systemctl --user start xdg-desktop-portal &

# Apply portrait transform after compositor is ready (setting it in config
# causes a DRM atomic commit failure on startup, so we apply it post-init).
swaymsg "output $LEFT_VERTICAL transform 270"
swaymsg 'workspace 1; layout splitv'

nm-applet --indicator &
blueman-applet &
spotify &
slack &
wezterm &
firefox &

# Wait for both workspace 1 apps to be in the tree, then put Spotify below Slack.
wait_for_app '"app_id": "slack"' && \
wait_for_app '"class": "Spotify"' && \
swaymsg '[class="Spotify"] focus; move down'
