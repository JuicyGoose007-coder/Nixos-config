{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./ghostty.nix
    ./kitty.nix
    ./starship.nix
    ./waybar.nix
    ./superfile.nix
    ./hyprlock.nix
    ./nvim
    ./niri
    ./tmux.nix
    ./fastfetch.nix
    ./wlogout.nix
    ./rofi.nix
    ./git.nix
    ./nls.nix
    ./iris.nix
    ./xdg-mime.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.claude-code.enable = true;

  stylix.enableReleaseChecks = false;
  stylix.targets.waybar.enable = true;
  stylix.targets.fzf.enable = true;
  stylix.targets.starship.enable = true;
  stylix.targets.tmux.enable = true;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.neovim.enable = false;
  stylix.targets.kitty.enable = true;
  stylix.targets.ghostty.enable = true;

  # Unlock tinted-tmux's powerline status bar (session left, date/time/host right).
  # stylix's tmux target sources the tinted-tmux template, whose fuller status bar is
  # gated behind this shell env var; set it session-wide so the tmux server inherits it.
  home.sessionVariables.TINTED_TMUX_OPTION_STATUSBAR = "1";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 20;
  };
}
