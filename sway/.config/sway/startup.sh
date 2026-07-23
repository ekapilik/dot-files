#!/usr/bin/env bash

wait_for_app() {
    local search="$1"
    for i in $(seq 1 60); do
        swaymsg -t get_tree 2>/dev/null | grep -q "$search" && return 0
        sleep 0.5
    done
    return 1
}

# Apply portrait transform after compositor is ready (setting it in config
# causes a DRM atomic commit failure on startup, so we apply it post-init).
swaymsg 'output DP-6 transform 270'
swaymsg 'workspace 1; layout splitv'

spotify &
slack &
wezterm &
firefox &

# Wait for both workspace 1 apps to be in the tree, then put Spotify below Slack.
wait_for_app '"app_id": "slack"' && \
wait_for_app '"class": "Spotify"' && \
swaymsg '[class="Spotify"] focus; move down'
