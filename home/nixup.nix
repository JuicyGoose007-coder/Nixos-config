{ pkgs, ... }:

let
  nixup = pkgs.writeShellApplication {
    name = "nixup";

    # nvd isn't on PATH otherwise. git is listed explicitly rather than
    # relied on: it's only present because programs.git is enabled, and a
    # script shouldn't depend on that.
    runtimeInputs = [
      pkgs.nvd
      pkgs.git
    ];

    text = ''
      # nixup - build the new system, show what changed, then decide.
      #
      # Building needs no root and touches nothing. Only the final activation
      # does, so aborting at the prompt leaves the machine exactly as it was.
      #
      #   nixup       build what flake.lock already pins, then switch. Never updates.
      #   nixup -u    update flake.lock first, and revert it if we don't activate.
      #   nixup -b    activate at next boot instead of now.
      #   nixup -n    dry run: build and show the diff, then stop.

      update=0
      switched=0
      dryrun=0
      mode="switch"

      while getopts "ubn" opt; do
        case "$opt" in
          u) update=1 ;;
          b) mode="boot" ;;
          n) dryrun=1 ;;
          *) echo "Usage: nixup [-u] [-b] [-n]" >&2; exit 1 ;;
        esac
      done

      # The profile symlink looks like `system-44-link`; strip everything
      # that isn't a digit to get the generation number.
      generation() {
        readlink /nix/var/nix/profiles/system | tr -dc '0-9'
      }

      # Runs however the script ends: clean finish, abort, dry run, or a build
      # failure under set -e. If we bumped flake.lock but never activated
      # anything, put it back - a lock pinning versions you never ran is worse
      # than no bump at all. (`switched` covers -b too: setting the next boot
      # counts as earning the bump.)
      #
      # Caveat: this can't tell its own bump from edits you already had in
      # flight, so it restores flake.lock wholesale.
      revert_lock() {
        if [ "$update" -eq 1 ] && [ "$switched" -eq 0 ]; then
          echo "Reverting flake.lock - nothing was activated."
          git -C /etc/nixos checkout -- flake.lock
        fi
      }
      trap revert_lock EXIT

      # --flake instead of `cd /etc/nixos` first: no directory side effects.
      # Note that positional args to `nix flake update` are input NAMES, not
      # paths, so `nix flake update /etc/nixos` would be wrong.
      if [ "$update" -eq 1 ]; then
        echo "Updating flake inputs..."
        nix flake update --flake /etc/nixos
        echo
      fi

      before=$(generation)

      echo "Building goosenest..."
      new=$(nix build --no-link --print-out-paths \
        "/etc/nixos#nixosConfigurations.goosenest.config.system.build.toplevel")

      # /run/current-system always points at what's running right now.
      echo
      nvd diff /run/current-system "$new"
      echo

      # Stop before the prompt. Note this exits with switched=0, so -n -u
      # still reverts the lock - a dry run never earns a bump.
      if [ "$dryrun" -eq 1 ]; then
        echo "Dry run - generation $before unchanged, nothing activated."
        exit 0
      fi

      while true; do
        read -r -p "[Enter] $mode   [n] abort: " key
        case "$key" in
          "") break ;;
          n | N) echo "Aborted." >&2; exit 1 ;;
          *) ;;
        esac
      done

      # `mode` is literally the nixos-rebuild subcommand: switch or boot.
      # Re-evaluates the flake, but everything is already in the store from
      # the build above, so this is quick.
      sudo nixos-rebuild "$mode" --flake "/etc/nixos#goosenest"

      # Only now is the lock bump earned. Set after activation, never before:
      # if it fails, set -e stops us above this line and the trap still sees
      # switched=0.
      switched=1

      after=$(generation)
      if [ "$mode" = "boot" ]; then
        echo "Generation $before -> $after, active at next boot."
      else
        echo "Generation $before -> $after."
      fi
    '';
  };
in
{
  home.packages = [ nixup ];
}
