#!/usr/bin/bash
#################
# JuicyGoose007 #
#################
set -euo pipefail

pkill -9 waybar


waybar & disown

#################
# End of Script #
#################
