{ ... }:

{
  programs.git = {
    enable   = true;
    settings.user = {
      name  = "Jake Turner";
      email = "jaketurner624@gmail.com";
    };
  };
}
