#!/usr/bin/env bash
# Apply portrait transform after compositor is ready (setting it in config
# causes a DRM atomic commit failure on startup, so we apply it post-init).
swaymsg 'output DP-6 transform 270'

# Set workspace 1 to vertical split so Slack (launched first) goes on top
# and Spotify goes below it.
swaymsg 'workspace 1; layout splitv'

# Spotify first so it lands at top; slack second so it lands below,
# then we move spotify down to get: slack top, spotify bottom.
spotify &
sleep 1
slack &
sleep 2
swaymsg '[class="Spotify"] focus; move down'
wezterm &
firefox &
