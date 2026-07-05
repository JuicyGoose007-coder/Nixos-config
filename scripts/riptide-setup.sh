#!/usr/bin/env bash
set -euo pipefail

CONTAINER="arch"
EXPORT_PATH="$HOME/.local/bin"

if distrobox list 2>/dev/null | grep -q "| $CONTAINER "; then
  echo "Container '$CONTAINER' already exists, skipping creation."
else
  echo "Creating arch container..."
  distrobox create --name "$CONTAINER" --image archlinux:latest --yes
fi

echo "Installing riptide..."
distrobox enter "$CONTAINER" -- bash -lc '
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm git base-devel

  if ! command -v paru >/dev/null 2>&1; then
    git clone https://aur.archlinux.org/paru.git /tmp/paru-build
    cd /tmp/paru-build && makepkg -si --noconfirm
  fi

  paru -S --noconfirm riptide
  distrobox-export --bin $(which riptide) --export-path ~/.local/bin
'

echo "Done — riptide available at $EXPORT_PATH/riptide"
