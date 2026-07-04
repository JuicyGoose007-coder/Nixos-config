{ ... }:

{
  programs.git = {
    enable   = true;
    settings.user = {
      name  = "Jake Turner";
      email = "jaketurner624@gmail.com";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      hostname     = "github.com";
      user         = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };
}
