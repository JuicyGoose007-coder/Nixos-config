# fastfetch — system info banner, run from the zsh init in dots/zshrc.
#
# Config is JSON under dots/, symlinked rather than generated — same reasoning as
# modules/rofi.nix.
{ ... }:

{
  flake.modules.homeManager.fastfetch =
    { pkgs, ... }:

    {
      home.packages = [ pkgs.fastfetch ];

      xdg.configFile."fastfetch".source = ../dots/fastfetch;
    };
}
