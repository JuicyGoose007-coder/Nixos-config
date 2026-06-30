{ config, lib, pkgs, ... }:

{
  imports = [
    ./home/packages.nix
    ./home/shell.nix
    ./home/ghostty.nix
    ./home/starship.nix
    ./home/waybar.nix
    ./home/yazi.nix
    ./home/hyprlock.nix
    ./home/nvim.nix
    ./home/niri.nix
    ./home/tmux.nix
    ./home/fastfetch.nix
    ./home/wlogout.nix
    ./home/rofi.nix
  ];

  home.username      = "juicygoose007";
  home.homeDirectory = "/home/juicygoose007";
  home.stateVersion  = "24.11";

  programs.home-manager.enable = true;
  programs.claude-code.enable  = true;

  stylix.targets.waybar.enable    = true;
  stylix.targets.fzf.enable       = true;
  stylix.targets.starship.enable  = true;
  stylix.targets.yazi.enable      = true;
  stylix.targets.hyprlock.enable  = false;
  stylix.targets.neovim.enable    = false;

  home.pointerCursor = {
    gtk.enable = true;
    package    = pkgs.adwaita-icon-theme;
    name       = "Adwaita";
    size       = 20;
  };
}
