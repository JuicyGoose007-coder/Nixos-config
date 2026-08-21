{ ... }:

{
  flake.modules.homeManager.gnome-disk-utility =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gnome-disk-utility ];
    };
}
