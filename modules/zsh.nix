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
    { lib, pkgs, ... }:
    {
      programs.fzf = {
        enable = true;
        # Home Manager emits `source <(fzf --zsh)` at mkOrder 910 — ahead of the
        # dots/zshrc body (1000) and the plugin block (1200). That ordering is
        # what makes this safe alongside fzf-tab: fzf --zsh ends with an
        # unqualified `bindkey '^I' fzf-completion`, but fzf-tab is sourced
        # later and takes ^I back. Verified in an isolated harness.
        #
        # Gains ^T (files) and Alt-C (cd), both bound in emacs/vicmd/viins.
        #
        # ^R is the real prize here — it replaces zsh's incremental search, and
        # dots/zshrc no longer rebinds it (see the note in zvm_after_init).
        enableZshIntegration = true;
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
          # mkBefore (order 500) lands ahead of the dots/zshrc body (1000), which
          # is required: zsh-completions ships 146 completion *functions* rather
          # than a sourceable plugin, so it has to be on fpath before dots/zshrc
          # calls compinit. Sourcing it like the other plugins would do nothing.
          (lib.mkBefore ''
            fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
          '')

          (builtins.readFile ../dots/zshrc)

          # Plugins from nixpkgs, loaded through zsh-defer.
          #
          # mkOrder 1200 puts this AFTER the dots/zshrc body (default order,
          # 1000) and BEFORE the zoxide block (mkAfter, 1500). Both edges
          # matter: `zvm_after_init` is defined in dots/zshrc, and with
          # ZVM_INIT_MODE=sourcing zsh-vi-mode calls it the moment it is
          # sourced — so it has to already exist by the time we get here.
          #
          # LOAD ORDER IS LOAD-BEARING and every failure here is silent:
          #   compinit    -> already run by dots/zshrc
          #   zsh-vi-mode -> FIRST, because it re-binds widgets on init; the
          #                  plugins below wrap what it leaves behind
          #   fzf-tab     -> after compinit, before anything wrapping widgets
          #   fsh         -> before history-substring-search, or hss's own
          #                  highlighting stops working with no error
          #   autosuggest -> needs _zsh_autosuggest_start called by hand
          #   hss         -> bind keys only once it is loaded
          # zsh-defer's queue is FIFO, so queue position *is* load order.
          (lib.mkOrder 1200 ''
            # ---- plugin loading (nixpkgs, not zinit) ----
            source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

            # ZVM_INIT_MODE=sourcing makes zsh-vi-mode initialise the moment it
            # is sourced, rather than on the first precmd. That matters because
            # zsh-defer also drains its queue on precmd: with the default
            # (last-zle) the two race, and whether vi-mode clobbers the plugins
            # below is down to luck. Sourcing mode makes the order deterministic
            # and is also what sets ZVM_MODE, which zvm_after_select_vi_mode in
            # dots/zshrc reads for the starship mode indicator.
            #
            # It calls zvm_after_init immediately, so that function (defined in
            # dots/zshrc, merged above at order 1000) must already exist here.
            ZVM_INIT_MODE=sourcing
            zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.zsh

            # fzf-tab shells out to the fzf binary and does not depend on
            # programs.fzf.enableZshIntegration; it just has to be sourced after
            # HM's `source <(fzf --zsh)` (order 910) so that it wins ^I back,
            # which this block's placement guarantees. Loaded before fsh and
            # autosuggestions per its own docs.
            zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
            zsh-defer eval 'zstyle ":completion:*:descriptions" format "[%d]"'

            zsh-defer source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

            # The plugin normally registers its precmd hook at source time.
            # Sourced from inside a precmd (which is what zsh-defer does) that
            # registration is missed, and ghost text silently never appears —
            # so start it explicitly.
            zsh-defer source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
            zsh-defer eval 'ZSH_AUTOSUGGEST_STRATEGY=(history completion); _zsh_autosuggest_start'

            zsh-defer source ${pkgs.zsh-history-substring-search}/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
            zsh-defer eval 'bindkey -M viins "^[[A" history-substring-search-up; bindkey -M viins "^[[B" history-substring-search-down'
          '')
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
