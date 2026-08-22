# NetworkManager plus its tray applet — the service and its UI are one topic.
{ ... }:

{
  flake.modules.nixos.networkmanager =
    { username, ... }:
    {
      networking.networkmanager.enable = true;

      users.users.${username}.extraGroups = [ "networkmanager" ];
    };

  flake.modules.homeManager.networkmanager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.networkmanagerapplet ];
    };
}
