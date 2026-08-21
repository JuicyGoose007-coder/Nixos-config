{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    gcc
    go

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

  ];
}
