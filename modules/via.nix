{ ... }:

{
  flake.modules.homeManager.via =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.via ];
    };
}
