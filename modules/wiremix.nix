{ ... }:

{
  flake.modules.homeManager.wiremix =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wiremix ];
    };
}
