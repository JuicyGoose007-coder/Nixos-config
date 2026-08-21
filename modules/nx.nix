# Addressable as /etc/nixos#nx; home/nx.nix installs it.
{
  perSystem =
    { pkgs, ... }:
    let
      unwrapped = pkgs.writeShellApplication {
        name = "nx";

        runtimeInputs = [
          pkgs.nvd
          pkgs.nix-output-monitor
          pkgs.git
        ];

        # writeShellApplication adds the shebang and `set -euo pipefail`.
        text = builtins.readFile ../scripts/nx.sh;
      };
    in
    {
      # site-functions is already on fpath via NIX_PROFILES. Any shallower and
      # compaudit rejects it: a store root's parent is group-writable /nix/store.
      packages.nx = pkgs.symlinkJoin {
        name = "nx";
        paths = [ unwrapped ];
        postBuild = ''
          install -Dm444 ${../dots/zsh/completions/_nx} \
            "$out/share/zsh/site-functions/_nx"
        '';
      };
    };
}
