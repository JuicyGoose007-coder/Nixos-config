{ ... }:

{
  # Root cause of the headless-nvim orphans: the packaged `nvim.desktop` has
  # `Terminal=true`, but under niri there's no freedesktop "default terminal" to
  # honour it — so xdg-open/gio fall back to running `nvim %F` with no window/TTY.
  #
  # Fix: ship our own entry that launches nvim *inside* Ghostty (a real terminal
  # we already run) with `terminal = false`, then make it the explicit default for
  # text files so associations no longer resolve to the bare nvim.desktop.

  xdg.desktopEntries.nvim-ghostty = {
    name = "Neovim (Ghostty)";
    genericName = "Text Editor";
    comment = "Edit text files in Neovim inside Ghostty";
    icon = "nvim";
    exec = "ghostty -e nvim %F";
    terminal = false; # Ghostty IS the terminal — don't ask the launcher to wrap it
    categories = [ "Utility" "TextEditor" "Development" ];
    mimeType = [
      "text/plain"
      "text/x-nix"
    ];
  };

  xdg.mimeApps = {
    enable = true;

    # Migrated verbatim from the previously-unmanaged ~/.config/mimeapps.list so
    # enabling HM management doesn't drop your browser / scheme handlers.
    defaultApplications = {
      # Text editing — the fix: .nix files are detected as text/plain, which is the
      # association that was spawning the headless nvim orphans.
      "text/plain" = "nvim-ghostty.desktop";
      "text/x-nix" = "nvim-ghostty.desktop";

      # Web / HTML → Firefox
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";

      # App scheme handlers
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      "x-scheme-handler/wootwoot" = "wootility.desktop";
      "x-scheme-handler/web+wootwoot" = "wootility.desktop";
    };

    # Ported from the old file's [Added Associations] block.
    associations.added = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
  };
}
