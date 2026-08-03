{
  description = "JuicyGoose007's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iris = {
      url = "github:versenilvis/iris";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      stylix,
      nix-index-database,
      zen-browser,
      niri,
      ...
    }@inputs:
    let
      # Build a full NixOS system from a hostname. Adding a machine later is
      # then a one-liner: `laptop = mkHost { hostname = "laptop"; };`.
      mkHost =
        {
          hostname,
          username ? "juicygoose007",
          system ? "x86_64-linux",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            ./hosts/${hostname}
            ./modules/nixos
            stylix.nixosModules.stylix
            {
              disabledModules = [
                "${stylix}/modules/kmscon/nixos.nix"
                "${stylix}/modules/regreet/nixos.nix"
              ];
            }
            nix-index-database.nixosModules.nix-index
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = {
                inherit inputs username;
              };
              home-manager.sharedModules = [
                nixvim.homeModules.nixvim
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations.goosenest = mkHost { hostname = "goosenest"; };
    };
}
