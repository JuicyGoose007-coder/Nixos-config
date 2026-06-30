#!/usr/bin/env bash

# Available themes: subtle, velvetline

waybar_config_dir="/home/$USER/.config/waybar"

killall -9 waybar
killall -9 swaync

swaync &

waybar &
