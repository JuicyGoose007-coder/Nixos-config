# The authentication agent itself is spawned by niri at startup, which
# references this package by store path (modules/niri/_sections/startup.nix).
{ ... }:

{
  flake.modules.nixos.polkit =
    { pkgs, ... }:
    {
      security.polkit.enable = true;

      environment.systemPackages = [ pkgs.polkit_gnome ];
    };
}
