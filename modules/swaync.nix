{ ... }:

{
  flake.modules.homeManager.swaync =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.swaynotificationcenter ];
    };
}
