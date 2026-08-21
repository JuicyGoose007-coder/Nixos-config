{ ... }:

{
  flake.modules.homeManager.pavucontrol =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pavucontrol ];
    };
}
