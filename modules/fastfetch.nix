# fastfetch — system info banner, run from the zsh init in dots/zshrc.
#
# Config is JSON under dots/, symlinked rather than generated — same reasoning as
# modules/rofi.nix. `../dots/fastfetch` resolves identically from modules/ as it
# did from home/.
{ ... }:

{
  flake.modules.homeManager.fastfetch =
    { ... }:

    {
      xdg.configFile."fastfetch".source = ../dots/fastfetch;
    };
}
