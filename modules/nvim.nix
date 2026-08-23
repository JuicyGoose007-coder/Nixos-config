{ inputs, ... }:

{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      # Home-manager modules, not flake-parts ones — the _ keeps import-tree out.
      imports = [
        inputs.nixvim.homeModules.nixvim
        ./nvim/_parts/plugins.nix
        ./nvim/_parts/keymaps.nix
        ./nvim/_parts/lua.nix
      ];

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
        categories = [
          "Utility"
          "TextEditor"
          "Development"
        ];
        mimeType = [
          "text/plain"
          "text/x-nix"
        ];
      };

      xdg.mimeApps = {
        enable = true;
        # .nix files are detected as text/plain, which is the association that was
        # spawning the headless nvim orphans.
        defaultApplications = {
          "text/plain" = "nvim-ghostty.desktop";
          "text/x-nix" = "nvim-ghostty.desktop";
        };
      };

      # conform-nvim's formatters. In home.packages rather than extraPackages
      # below so they stay on the interactive PATH too.
      home.packages = [
        pkgs.stylua
        pkgs.ruff
        pkgs.rustfmt
        pkgs.prettier
        pkgs.taplo
      ];

      programs.nixvim = {
        enable = true;
        nixpkgs.source = pkgs.path;

        # Formatter binaries must be on Neovim's PATH — enabling the LSP / naming a
        # conform formatter does NOT install them. nixfmt provides the `nixfmt`
        # binary (RFC-style), used by both nixd (LSP format) and conform.
        extraPackages = [ pkgs.nixfmt ];

        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        opts = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          smartindent = true;
          wrap = true;
          linebreak = true;
          breakindent = true;
          termguicolors = true;
          scrolloff = 8;
          signcolumn = "yes";
          autoread = true;
          mouse = "a";
          undofile = true;
          clipboard = "unnamedplus";
          ignorecase = true;
          smartcase = true;
          cursorline = true;
          cmdheight = 1;
        };
      };
    };
}
