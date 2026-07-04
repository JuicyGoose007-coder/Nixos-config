{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    protonplus
    wlogout
    tmux
    cargo
    gcc
    obsidian
    via

    # Other distro packages
    distrobox
    docker

    #Extra browser
    brave

    # Wayland tools
    wl-clipboard
    wlr-randr
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
    waybar
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
    git
    lazygit
    eza
    python3
    bat

    # Formatters for conform-nvim
    stylua
    ruff
    rustfmt
    prettier
    taplo
  ];
}
