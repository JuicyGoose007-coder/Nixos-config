# The account itself. Group memberships that belong to a topic are contributed
# by that topic's aspect — extraGroups is a listOf str, so the definitions
# concatenate (docker.nix adds "docker", networkmanager.nix adds its own).
{ ... }:

{
  flake.modules.nixos.user =
    { username, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        description = "Jake Turner";
        extraGroups = [
          "wheel"
          "input"
        ];
        home = "/home/${username}";
      };
    };
}
