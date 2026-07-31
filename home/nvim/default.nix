{ pkgs, ... }:

{
  imports = [
    ./plugins.nix
    ./keymaps.nix
    ./lua.nix
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

    # ── Colorscheme ──────────────────────────────────────────────────────────
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast_dark = "hard";
        italic.strings = true;
      };
    };
  };
}
