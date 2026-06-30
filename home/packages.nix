{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    protonplus
    wlogout
    tmux
    cargo
    gcc

    # Wayland tools
    wl-clipboard
    wlr-randr
    grim
    slurp
    swappy
    awww

    # Lock screen
    hyprlock

    # Storage & files
    udiskie
    nautilus

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

    # Formatters for conform-nvim
    stylua
    ruff
    rustfmt
    prettier
    taplo
  ];
}
