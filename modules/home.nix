# The home-manager base: who this config is for and the state version it was
# written against. Everything else lives in a topic aspect.
{ ... }:

{
  flake.modules.homeManager.home =
    { username, ... }:
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      # Records the home-manager release this profile was first built against —
      # never bump it to match nixpkgs.
      home.stateVersion = "24.11";

      programs.home-manager.enable = true;
    };
}
