{ ... }:

{
  flake.modules.homeManager.gpu =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nvtopPackages.nvidia ];
    };
}
