# kio-fuse and kservice are not programs you run — they are what makes
# dolphin's file dialogs and thumbnails work.
{ ... }:

{
  flake.modules.homeManager.dolphin =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.kdePackages.dolphin
        pkgs.kdePackages.kio-fuse
        pkgs.kdePackages.kservice.out
      ];
    };
}
