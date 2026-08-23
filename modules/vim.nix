# vim, deliberately unmanaged — the vimrc and its plugins live in ~/.vim, outside
# the flake. Nix's whole job here is the binary and the servers it shells out to.
{ ... }:

{
  flake.modules.homeManager.vim =
    { pkgs, ... }:
    {
      # Not programs.vim.enable: it wraps vim as `vim -u <store vimrc>`, which
      # makes vim skip ~/.vimrc entirely — the hand-written config would appear
      # to do nothing. Forfeits stylix's vim target, which hooks that module's
      # extraConfig; a colorscheme plugin covers it instead.
      #
      # vim-full over vim for +wayland_clipboard — plain vim is -clipboard, and
      # v:clipproviders would have to be hand-written.
      #
      # The servers sit here rather than in nixvim's extraPackages because that
      # PATH is private to neovim, and an unmanaged vim sees only the
      # interactive one. The list mirrors g:lspServers in ~/.vimrc.
      home.packages = with pkgs; [
        (lib.lowPrio vim-full)
        nixd
        nixfmt
        lua-language-server
        pyright
        rust-analyzer
        taplo
      ];

      # vim-full ships vim.desktop (Terminal=true) and gvim.desktop, both
      # claiming text/plain, x-shellscript, x-csrc and friends. text/plain has a
      # default pinned in modules/nvim.nix; the rest do not, so they resolve to
      # a GTK gvim, or to the Terminal=true entry that spawned the headless
      # orphans that aspect exists to stop.
      #
      # These same-named entries carry no MimeType, so both leave
      # mimeinfo.cache. Home-manager builds them into home.packages, not into
      # ~/.local/share, so they collide with vim-full inside one buildEnv —
      # hence lowPrio above: without it the winner is list order.
      xdg.desktopEntries = {
        vim = {
          name = "Vim";
          exec = "ghostty -e vim %F";
          noDisplay = true;
        };
        gvim = {
          name = "GVim";
          exec = "ghostty -e vim %F";
          noDisplay = true;
        };
      };
    };
}
