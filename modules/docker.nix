# Container backend. distrobox is a consumer and keeps its own aspect.
{ ... }:

{
  flake.modules.nixos.docker =
    { username, ... }:
    {
      virtualisation.docker.enable = true;

      users.users.${username}.extraGroups = [ "docker" ];
    };
}
