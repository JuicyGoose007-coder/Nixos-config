{ ... }:

{
  flake.modules.homeManager.distrobox =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.distrobox ];
    };
}
