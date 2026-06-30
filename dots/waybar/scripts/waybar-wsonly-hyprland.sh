#!/usr/bin/env sh

killall -q waybar
while pgrep -x waybar >/dev/null; do sleep 1; done

waybar -c ~/.config/waybar/config-hyprland-wsonly -s ~/.config/waybar/style-wsonly.css &
