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

    # iris hardcodes its "Aura" hex palette (lipgloss.Color) in one file with
    # no color config, so we swap those literals for the stylix palette at
    # build time. --replace-warn logs (doesn't fail) if upstream changes a hex.
    postPatch = ''
      substituteInPlace integration/overlay.go \
        --replace-warn '#a277ff' '${c.base0E}' \
        --replace-warn '#61ffca' '${c.base0C}' \
        --replace-warn '#edecee' '${c.base05}' \
        --replace-warn '#ffffff' '${c.base07}' \
        --replace-warn '#9692a8' '${c.base04}' \
        --replace-warn '#6d6a7f' '${c.base03}' \
        --replace-warn '#4B4A4C' '${c.base03}' \
        --replace-warn '#3d375e' '${c.base02}' \
        --replace-warn '#2a2342' '${c.base01}' \
        --replace-warn '#1a2d36' '${c.base01}' \
        --replace-warn '#1e1d28' '${c.base01}' \
        --replace-warn '#110f18' '${c.base00}'
    '';

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
      "hidden-files" = false;
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
in
{
  home.packages = [ iris ];

  xdg.configFile."iris/config.toml".source = tomlFormat.generate "iris-config.toml" irisSettings;
}
