{ lib, ... }:

{
  programs.fzf = {
    enable             = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable             = true;
    # Init manually below so it runs LAST (see initContent). Home Manager's
    # integration injects the eval near the top of .zshrc, which makes
    # `zoxide doctor` warn that later plugins can clobber its hooks.
    enableZshIntegration = false;
  };

  programs.zsh = {
    enable           = true;
    enableCompletion = false;
    initContent      = lib.mkMerge [
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
}
