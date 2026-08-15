# nixup, as a real package. A flake-parts module: everything under ./modules is
# imported automatically by import-tree (see flake.nix), so this file is never
# imported by name.
#
# perSystem is instantiated once per entry in modules/systems.nix, which is why
# no system string appears here. That makes the package addressable as
# `/etc/nixos#nixup`, so it can be built or run without installing it:
#
#   nix build /etc/nixos#nixup
#   nix run /etc/nixos#nixup -- -n
#
# home/nixup.nix is now only a consumer of this output.
{
  perSystem =
    { pkgs, ... }:
    {
      packages.nixup = pkgs.writeShellApplication {
        name = "nixup";

        # Neither of these is on PATH otherwise. The lockfile revert uses
        # cp/mktemp from coreutils, so nothing else is needed.
        runtimeInputs = [
          pkgs.nvd
          pkgs.nix-output-monitor
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

          lock=/etc/nixos/flake.lock

          update=0
          switched=0
          dryrun=0
          mode="switch"
          backup=""

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
          # failure under set -e. If we bumped the lock but never activated
          # anything, put back the copy we took before updating - a lock pinning
          # versions you never ran is worse than no bump at all. (`switched` covers
          # -b too: setting the next boot counts as earning the bump.)
          #
          # Restoring the snapshot rather than `git checkout` matters: this undoes
          # exactly our own change, so a lock you already had modified before
          # running nixup survives untouched.
          revert_lock() {
            [ -n "$backup" ] || return 0
            if [ "$switched" -eq 0 ]; then
              echo "Reverting flake.lock - nothing was activated."
              cp "$backup" "$lock"
            fi
            rm -f "$backup"
          }
          trap revert_lock EXIT

          # --flake instead of `cd /etc/nixos` first: no directory side effects.
          # Note that positional args to `nix flake update` are input NAMES, not
          # paths, so `nix flake update /etc/nixos` would be wrong.
          if [ "$update" -eq 1 ]; then
            # Assign `backup` only once the copy succeeded - otherwise a failed cp
            # would leave the trap restoring from an empty file.
            snapshot=$(mktemp)
            cp "$lock" "$snapshot"
            backup="$snapshot"

            echo "Updating flake inputs..."
            nix flake update --flake /etc/nixos
            echo
          fi

          before=$(generation)

          # nom wraps nix build with a live dependency tree instead of a wall of
          # store paths. It renders to stderr and still prints the built path to
          # stdout, so capturing it here works exactly as with plain nix build.
          echo "Building goosenest..."
          new=$(nom build --no-link --print-out-paths \
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

          # Activate exactly the path that was built and diffed above.
          #
          # This used to be `sudo nixos-rebuild "$mode" --flake ...`, which
          # re-evaluates the flake and activates whatever *that* evaluation
          # produces — $new was only ever used for the nvd diff. The two
          # normally agree, so it looked fine, but they are two independent
          # evaluations and nothing guarantees it: on 2026-08-15 a switch landed
          # on a toplevel that differed from the diffed one, and the generation
          # that got activated was never the one shown. That makes the diff
          # advisory rather than binding, which defeats the point of the prompt.
          #
          # These two commands are what nixos-rebuild does internally once a
          # system is built, minus the second evaluation. --set makes it the
          # current generation; switch-to-configuration activates it. `mode` is
          # switch or boot, which switch-to-configuration takes verbatim.
          sudo nix-env --profile /nix/var/nix/profiles/system --set "$new"
          sudo "$new/bin/switch-to-configuration" "$mode"

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
    };
}
