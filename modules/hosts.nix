# Host assembly. A flake-parts module: everything under ./modules is imported
# automatically by import-tree (see flake.nix), so this file is never imported
# by name — it just declares what it contributes to the flake.
{ inputs, ... }:

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
        ../system
        inputs.stylix.nixosModules.stylix
        {
          disabledModules = [
            "${inputs.stylix}/modules/kmscon/nixos.nix"
            "${inputs.stylix}/modules/regreet/nixos.nix"
          ];
        }
        inputs.nix-index-database.nixosModules.nix-index
        inputs.niri.nixosModules.niri
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ../home;
          home-manager.extraSpecialArgs = {
            inherit inputs username;
          };
          home-manager.sharedModules = [
            inputs.nixvim.homeModules.nixvim
          ];
        }
      ];
    };
in
{
  flake.nixosConfigurations.goosenest = mkHost { hostname = "goosenest"; };
}
