#!/usr/bin/env sh

# Terminate already running bar instances
pkill waybar

# Wait until the processes have been shut down
while pgrep waybar >/dev/null; do sleep 1; done

# Launch main
waybar &
disown
