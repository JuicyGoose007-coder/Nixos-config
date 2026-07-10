{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    protonplus
    wlogout
    cargo
    gcc
    obsidian
    via

    # Other distro packages
    distrobox

    #Extra browser
    brave

    # Wayland tools
    wl-clipboard
    wlr-randr
    wayland-utils
    grim
    slurp
    swappy
    awww

    # Storage & files
    gnome-disk-utility
    nautilus
    kdePackages.dolphin
    kdePackages.kio-fuse

    # Status bar & launcher
    fuzzel
    rofi

    # Notifications
    mako
    swaynotificationcenter

    # Terminals
    kitty

    # Audio & media
    pavucontrol
    playerctl
    wiremix
    mpv

    # System utilities
    networkmanagerapplet
    brightnessctl
    htop
    btop
    fastfetch
    ripgrep
    jq
    file
    wget
    curl
    lazygit
    eza
    python3
    bat
    nvtopPackages.nvidia

    # Formatters for conform-nvim
    stylua
    ruff
    rustfmt
    prettier
    taplo
  ];
}
