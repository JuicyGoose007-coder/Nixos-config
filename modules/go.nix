{ ... }:

{
  flake.modules.homeManager.go =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.go ];
    };
}
