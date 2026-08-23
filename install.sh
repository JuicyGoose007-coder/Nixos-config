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
USERNAME="juicygoose007"
USER_HOME="/home/$USERNAME"
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

# Avoid deleting the shell's own cwd out from under it (causes
# "getcwd: cannot access parent directories" on every command after).
cd /

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
  --flake "$NIXOS_DIR#goosenest" \
  --option experimental-features "nix-command flakes"

# ── Vim ──────────────────────────────────────────────────────────────────────
# modules/vim.nix installs the binary and the language servers but leaves the
# config unmanaged on purpose, so nothing else puts these in place. Runs after
# the rebuild because that is what creates the user and its home.

echo "==> Setting up vim..."

# 'undodir' and friends fail silently when their directory is missing.
install -d -o "$USERNAME" -g users \
  "$USER_HOME"/.vim/{autoload,undo,swap,backup,plugged}

# Never clobber an existing vimrc: past the first install this file is the
# user's, and the repo copy is only a starting point.
if [[ -e "$USER_HOME/.vimrc" ]]; then
  echo "    ~/.vimrc already exists, leaving it alone"
else
  install -o "$USERNAME" -g users -m 644 "$NIXOS_DIR/dots/vimrc" "$USER_HOME/.vimrc"
fi

if [[ -e "$USER_HOME/.vim/autoload/plug.vim" ]]; then
  echo "    vim-plug already present"
elif curl -fsSL -o "$USER_HOME/.vim/autoload/plug.vim" \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
  chown "$USERNAME:users" "$USER_HOME/.vim/autoload/plug.vim"
  echo "    vim-plug installed — run :PlugInstall in vim"
else
  echo "    warning: could not fetch vim-plug; vim will error until you do" >&2
fi

echo ""
echo "==> Done! Reboot to start niri."

