{ ... }:

{
  programs.fzf = {
    enable             = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable             = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable           = true;
    enableCompletion = false;
    initContent      = builtins.readFile ../dots/zshrc;
  };
}
