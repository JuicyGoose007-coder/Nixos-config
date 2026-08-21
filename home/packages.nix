{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    cargo
    gcc
    obsidian
    via
    go

    # Gaming
    protonplus

    # Other distro packages
    distrobox

    #Extra browser
    brave
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Wayland tools
    grim
    slurp
    swappy

    # Storage & files
    gnome-disk-utility
    nautilus
    kdePackages.dolphin
    kdePackages.kio-fuse
    kdePackages.kservice.out

    # Notifications
    swaynotificationcenter

    # Audio & media
    pavucontrol
    playerctl
    wiremix

    # System utilities
    networkmanagerapplet
    brightnessctl
    htop
    btop
    ripgrep
    jq
    file
    wget
    curl
    eza
    python3
    bat
    nvtopPackages.nvidia
    qbittorrent

  ];
}
