# rofi — application launcher.
#
# Config is a directory of .rasi files under dots/, symlinked into place rather
# than generated: it is upstream theme data, not something worth expressing as
# Nix. Same reasoning as dots/zshrc in modules/zsh.nix.
#
# `../dots/rofi` resolves to the same path from modules/ as it did from home/ —
# both are one level under the flake root.
{ ... }:

{
  flake.modules.homeManager.rofi =
    { pkgs, ... }:

    {
      home.packages = [ pkgs.rofi ];

      xdg.configFile."rofi".source = ../dots/rofi;
    };
}
