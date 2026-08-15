# zsh — the shell topic: zsh itself plus the two tools wired directly into its
# init (fzf, zoxide).
#
# The third aspect converted to the dendritic pattern, after modules/superfile.nix
# and modules/mpv.nix. This is a *flake-parts* module (import-tree in flake.nix
# loads everything under ./modules), and it registers a home-manager module under
# `flake.modules.homeManager.zsh` rather than configuring home-manager directly.
# modules/hosts.nix imports the whole registry with `builtins.attrValues`, so
# creating this file wires it in — there is no import list to touch.
#
# The option `flake.modules.<class>.<name>` is declared by modules/aspects.nix.
#
# Moved verbatim from home/shell.nix. `../dots/zshrc` resolves to the same path
# from modules/ as it did from home/ (both are one level under the flake root),
# so the readFile needed no adjustment and this migration is a pure no-op —
# verified by the toplevel drvPath being unchanged.
#
# fzf and zoxide live here rather than in their own aspects because neither is
# configured independently: both exist only as zsh integrations, and both have
# their Home Manager zsh hooks deliberately disabled in favour of hand-placed
# init below. Splitting them out would put one topic in three files.
{ ... }:

{
  flake.modules.homeManager.zsh =
    # Ordinary home-manager module from here down. `lib` is taken here, not on
    # the outer flake-parts module: mkMerge/mkAfter are evaluated as part of the
    # home-manager config, so it is this function that needs it.
    { lib, ... }:
    {
      programs.fzf = {
        enable = true;
        # Disabled: fzf's zsh hooks (Ctrl-T / Alt-C / **<Tab> fuzzy trigger) overlap
        # with the iris autocomplete overlay. Binary stays installed for other uses.
        enableZshIntegration = false;
      };

      programs.zoxide = {
        enable = true;
        # Init manually below so it runs LAST (see initContent). Home Manager's
        # integration injects the eval near the top of .zshrc, which makes
        # `zoxide doctor` warn that later plugins can clobber its hooks.
        enableZshIntegration = false;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = false;
        initContent = lib.mkMerge [
          (builtins.readFile ../dots/zshrc)
          # mkAfter pushes this to the very end of .zshrc. zoxide is genuinely
          # last, but zsh-vi-mode registers hooks asynchronously after init, which
          # trips `zoxide doctor` with a false positive — so silence it explicitly.
          (lib.mkAfter ''
            export _ZO_DOCTOR=0
            eval "$(zoxide init zsh)"
          '')
        ];
      };
    };
}
