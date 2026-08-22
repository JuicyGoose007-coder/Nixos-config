# comma — run a program without installing it (`, cowsay`). Backed by
# nix-index-database, whose input this aspect owns.
{ inputs, ... }:

{
  flake.modules.nixos.comma =
    { ... }:
    {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];

      programs.nix-index-database.comma.enable = true;
    };
}
