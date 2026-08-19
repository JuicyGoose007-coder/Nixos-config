{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    ./packages.nix
    ./starship.nix
    ./hyprlock.nix
    ./nvim
    ./niri
    ./tmux.nix
    ./nls.nix
    ./xdg-mime.nix
    ./nixup.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.claude-code.enable = true;

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
