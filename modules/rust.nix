# gcc rides along as cargo's linker.
{ ... }:

{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.cargo
        pkgs.gcc
      ];
    };
}
