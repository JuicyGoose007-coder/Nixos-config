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

      # Deleting this flips the target to true and stylix fights everforest below.
      stylix.targets.neovim.enable = false;

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

        colorschemes.everforest = {
          enable = true;
          settings = {
            background = "soft";
            enable_italic = 1;
          };
        };
      };
    };
}
