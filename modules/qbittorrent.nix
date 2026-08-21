{ ... }:

{
  flake.modules.homeManager.qbittorrent =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.qbittorrent ];
    };
}
