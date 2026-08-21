{ ... }:

{
  flake.modules.homeManager.nm-applet =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.networkmanagerapplet ];
    };
}
