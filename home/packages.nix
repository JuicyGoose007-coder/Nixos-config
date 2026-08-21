{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    gcc
    go

    # System utilities
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
