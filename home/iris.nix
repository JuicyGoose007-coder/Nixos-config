{
  pkgs,
  config,
  inputs,
  ...
}:

let
  # Stylix base16 palette (with leading '#'), used to re-theme iris below.
  c = config.lib.stylix.colors.withHashtag;

  # Built here (not inputs.iris.packages.*.default) because upstream's flake
  # ships a stale vendorHash; same buildGoModule args, corrected hash.
  iris = pkgs.buildGoModule {
    pname = "iris";
    version = inputs.iris.shortRev or "dirty";
    src = inputs.iris;

    subPackages = [ "cmd/iris" ];

    proxyVendor = true;
    vendorHash = "sha256-q1szUQkhdKq2VhMuWYYWTahmDxGeVjvHLmjciZu3cBU=";

    doCheck = false;

    meta = with pkgs.lib; {
      description = "Highly customizable, context-aware CLI autocomplete/navigation tool";
      homepage = "https://github.com/versenilvis/iris";
      license = licenses.mit;
      mainProgram = "iris";
    };
  };

  tomlFormat = pkgs.formats.toml { };

  # Declarative ~/.config/iris/config.toml. This file is the source of truth;
  # runtime `iris config` edits won't persist (it's a /nix/store symlink).
  irisSettings = {
    core = {
      version = 1;
      shell = "zsh";
      "shell-login" = false;
      mode = "last";
      debug = false;
      "expand-alias" = true;
      "auto-execute" = false;
    };
    ui = {
      style = "modern";
      "ghost-text" = true;
      "hidden-files" = true;
      "max-suggestions" = 100;
      "max-height" = 15;
      "max-width" = 0;
      "nerd-fonts" = true;
    };
    keybindings = {
      # Was ctrl+r (which stole zsh reverse-history-search); C-o mnemonic =
      # nvim insert-mode one-shot normal command, a brief "mode switch".
      "toggle-mode" = "ctrl+o";
      "toggle-menu" = "shift+tab"; # unchanged
      select = "tab"; # unchanged: accept highlighted menu item
      # nvim-style completion nav (C-n/C-p), matching blink-cmp; tmux-safe.
      "navigate-down" = "down";
      "navigate-up" = "up";
      # New: accept inline ghost text. Right arrow (iris default) — deliberately
      # New: accept inline ghost text. Right arrow (iris default) — deliberately
      # NOT ctrl+e, which in blink-cmp *cancels* the menu (opposite of accept).
      "navigate-right" = "right";
    };
    git = {
      "filter-active-branch" = true;
      "deduplicate-branches" = true;
    };
    updater = {
      # Nix owns the binary version, so don't self-update or nag.
      "check-on-startup" = false;
      channel = "stable";
      "check-interval" = "24h";
    };
    ai = {
      enabled = true;
      provider = "ollama";
      debounce_ms = 400;
      providers.ollama = {
        endpoint = "http://localhost:11434/v1/chat/completions";
        # Shared with git-aic (home/git.nix); 3B keeps ghost-text snappy on 8GB.
        model = "qwen2.5-coder:3b";
        timeout_ms = 5000;
      };
    };
  };
  irisTheme = {
    border = c.base09;
    accent = c.base0C;
    muted = c.base03;
    text = c.base05;
    text_sel = c.base07;
    key = c.base09;
    match = c.base0C;
    desc = c.base04;
    desc_sel = c.base05;
    sel_bg = c.base02;
    sel_text = c.base00;
    scroll_info = c.base09;
    ghost_text = c.base03;
    sys = c.base01;
    sys_sel = c.base09;
    hist = c.base01;
    hist_sel = c.base0C;
    alias = c.base01;
    alias_sel = c.base09;
  };
in
{
  home.packages = [ iris ];

  xdg.configFile."iris/config.toml".source = tomlFormat.generate "iris-config.toml" irisSettings;
  xdg.configFile."iris/theme.toml".source = tomlFormat.generate "iris-theme.toml" irisTheme;
}
