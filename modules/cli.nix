# The binaries with no config surface to grow into — a file each would be
# ceremony. Anything that gains one moves out to its own aspect.
{ ... }:

{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        htop
        btop
        nvtopPackages.nvidia
        ripgrep
        jq
        file
        wget
        curl
        eza
        bat
        brightnessctl
        playerctl
      ];
    };
}
