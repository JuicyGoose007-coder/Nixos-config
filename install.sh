#!/usr/bin/env bash
# Bootstrap script for a fresh NixOS install.
#
# Usage (from the NixOS installer or a minimal base install):
#   curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/Nixos-config/master/install.sh | sudo bash
#
# Or clone first, then run:
#   git clone https://github.com/JuicyGoose007-coder/Nixos-config.git /tmp/nixos-config
#   sudo bash /tmp/nixos-config/install.sh

set -euo pipefail

REPO_URL="https://github.com/JuicyGoose007-coder/Nixos-config.git"
NIXOS_DIR="/etc/nixos"
CLONE_TMP="/etc/nixos-new"
HW_CONFIG="$NIXOS_DIR/hardware-configuration.nix"
HW_BACKUP="/tmp/hardware-configuration.nix"

# ── Checks ──────────────────────────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
  echo "error: run this script as root (or with sudo)" >&2
  exit 1
fi

if [[ ! -f "$HW_CONFIG" ]]; then
  echo "error: $HW_CONFIG not found" >&2
  echo "       Run 'nixos-generate-config' first to generate it for this machine." >&2
  exit 1
fi

if ! command -v git &>/dev/null; then
  echo "error: git not found — install it first (nix-env -iA nixos.git)" >&2
  exit 1
fi

# ── Backup hardware config ───────────────────────────────────────────────────

echo "==> Saving hardware-configuration.nix..."
cp "$HW_CONFIG" "$HW_BACKUP"

# ── Clone repo ───────────────────────────────────────────────────────────────

echo "==> Cloning config..."
rm -rf "$CLONE_TMP"
git clone "$REPO_URL" "$CLONE_TMP"
rm -rf "$NIXOS_DIR"
mv "$CLONE_TMP" "$NIXOS_DIR"

# ── Restore hardware config ──────────────────────────────────────────────────

echo "==> Restoring hardware-configuration.nix..."
cp "$HW_BACKUP" "$HW_CONFIG"

# ── Rebuild ──────────────────────────────────────────────────────────────────

echo "==> Running nixos-rebuild switch..."
echo "    (this will take a while on first run)"
nixos-rebuild switch \
  --flake "$NIXOS_DIR#nixos" \
  --extra-experimental-features 'nix-command flakes'

echo ""
echo "==> Done! Reboot to start niri."
