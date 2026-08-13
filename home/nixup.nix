{ pkgs, ... }:

# nixup - build the new system, show what would change, then decide.
#
# The whole idea rests on one fact: in Nix, BUILDING and SWITCHING are two
# separate steps.
#
#   nix build            runs as you, no root. Puts the new system in
#                        /nix/store and hands back its path. Your running
#                        system is completely untouched.
#   nvd diff             compares the running system to the one you just
#                        built, and prints what changed.
#   nixos-rebuild switch needs root. This is the only irreversible step.
#
# Because there's a gap between them, we can look at the diff and back out.
#
# Companion file: home/git.nix - the git-aic derivation there has the same
# shape as this one. When you're unsure of the syntax, look there first.

let
  nixup = pkgs.writeShellApplication {
    name = "nixup";

    # writeShellApplication does three things for you:
    #   1. writes the script and puts it on your PATH as `nixup`
    #   2. adds `set -euo pipefail` to the top automatically
    #   3. runs shellcheck at BUILD time, so a typo fails your rebuild
    #      instead of silently misbehaving later
    #
    # runtimeInputs = packages whose binaries get added to PATH *inside* the
    # script. This is why git-aic can write plain `curl` instead of a long
    # /nix/store/... path.
    #
    # TODO 1: figure out what belongs here.
    #   Ask of each command your script will call: "is this guaranteed to
    #   exist on any NixOS box?"
    #     - nix, git, sudo, readlink  -> yes, always there. Not needed here.
    #     - nvd                       -> no. You installed it with `nix shell`
    #                                    to try it. Nothing installs it yet.
    #   Write it as `pkgs.nvd` (the `pkgs.` prefix matters).
    #   Later, in M4, `pkgs.nix-output-monitor` joins it.
    runtimeInputs = [
      # pkgs.nvd
    ];

    # A note on '' strings, because this trips up everyone once:
    #
    # Everything between '' and '' is your bash script. But Nix ALSO reads
    # this text looking for ${...} to substitute. So a bash variable written
    # as ${new} gets eaten by Nix and you get a confusing error about an
    # undefined variable.
    #
    # Two ways out:
    #   $new        - no braces, so Nix ignores it. This is what git.nix does
    #                 everywhere, and it's the easy path. Prefer it.
    #   ''${new}    - the escape hatch, when you genuinely need braces.
    #
    # Rule of thumb: write $new, not ${new}, and you'll never hit this.
    text = ''
      # ---------------------------------------------------------------
      # TODO 2: build the new system, capture its path in a variable.
      #
      # The command (you ran this by hand already, it took ~24s):
      #
      #   nix build --no-link --print-out-paths \
      #     /etc/nixos#nixosConfigurations.goosenest.config.system.build.toplevel
      #
      #   --no-link          don't create a ./result symlink
      #   --print-out-paths  print the store path to stdout so we can grab it
      #
      # To put a command's output into a variable, bash uses $( ):
      #   myvar=$(some command)
      #
      # Call it `new`. Tell the user something is happening first - a silent
      # 24-second pause looks like a hang. Use `echo`.
      # ---------------------------------------------------------------


      # ---------------------------------------------------------------
      # TODO 3: show the diff.
      #
      #   nvd diff /run/current-system "$new"
      #
      # /run/current-system is a symlink the OS maintains, always pointing at
      # the system you're running right now. Nothing to compute.
      #
      # Always put "$new" in double quotes. Unquoted variables split on spaces
      # and break in surprising ways - shellcheck will nag you about this, and
      # it's right.
      #
      # GOTCHA: remember `set -e` is on, so ANY command exiting non-zero kills
      # the script instantly. If nvd exits non-zero here and everything just
      # stops, that's why. `|| true` after a command ignores its exit code -
      # but only reach for it once you understand why the thing failed.
      # ---------------------------------------------------------------


      # ---------------------------------------------------------------
      # TODO 4: ask before switching.
      #
      # Copy the prompt loop from home/git.nix:88-97 almost verbatim - the
      # `while true` + `read -r -p` + `case` shape. Keeping the two tools
      # identical means one set of muscle memory.
      #
      # You want:  [Enter] switch   [n] abort
      # ([b] for boot comes later in M4 - don't build it yet.)
      #
      # For abort: print a message and `exit 1`.
      #
      # Why this is safe: if you abort, literally nothing happened. The build
      # just sits in the store until the next garbage collection.
      # ---------------------------------------------------------------


      # ---------------------------------------------------------------
      # TODO 5: switch.
      #
      #   sudo nixos-rebuild switch --flake /etc/nixos#goosenest
      #
      # This re-evaluates the flake, which looks wasteful given you just built
      # it. It isn't - everything is already in the store, so it just finds it
      # and takes a couple of seconds.
      #
      # This is the one step that needs sudo, and the one that changes your
      # machine. Everything above was read-only.
      # ---------------------------------------------------------------


      # Parking placeholder so the config still builds while TODOs are open.
      # Delete this once TODO 2 is written.
      echo "nixup: not implemented yet"
    '';
  };
in
{
  home.packages = [ nixup ];
}
