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

# Start the container and wait for distrobox's first-boot setup to finish before
# entering. On the Docker backend that setup (/dev/pts init, creating the host user
# inside the container) runs asynchronously, so entering too early races and fails
# with "openat dev/ptmx: no such device" or "no matching user". The entrypoint
# prints container_setup_done once it's ready; docker logs is cumulative so this is
# also safe/instant for an already-set-up container.
echo "Starting container and waiting for first-boot setup..."
docker start "$CONTAINER" >/dev/null
until docker logs "$CONTAINER" 2>&1 | grep -q container_setup_done; do
  sleep 1
done

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
