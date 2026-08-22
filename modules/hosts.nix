# Host assembly. A flake-parts module: everything under ./modules is imported
# automatically by import-tree (see flake.nix), so this file is never imported
# by name — it just declares what it contributes to the flake.
{ config, inputs, ... }:

let
  # Build a full NixOS system from a hostname. Adding a machine later is
  # then a one-liner: `laptop = mkHost { hostname = "laptop"; };`.
  mkHost =
    {
      hostname,
      username ? "juicygoose007",
      system ? "x86_64-linux",
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = [
        ../hosts/${hostname}
      ]
      # Every aspect that registered a NixOS half (modules/zsh.nix is the first).
      # `or { }` is defensive rather than necessary now: attrValues on a missing
      # attribute is an error, so this keeps working if the last nixos-class
      # aspect is ever removed again.
      ++ builtins.attrValues (config.flake.modules.nixos or { })
      ++ [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {
            imports = builtins.attrValues (config.flake.modules.homeManager or { });
          };
          home-manager.extraSpecialArgs = {
            inherit inputs username;
          };
        }
      ];
    };
in
{
  flake.nixosConfigurations.goosenest = mkHost { hostname = "goosenest"; };
}
