{ ... }:

{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.gamemode.enable = true;
      programs.gamescope.enable = true;

      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = false;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };

      hardware.steam-hardware.enable = true;

      fileSystems."/mnt/games" = {
        device = "/dev/disk/by-uuid/0ca9f5bb-3aa4-4050-8e12-5b69d3296659";
        fsType = "ext4";
        options = [
          "defaults"
          "nofail"
        ];
      };
    };

  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonplus ];
    };
}
