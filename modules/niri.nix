{ inputs, ... }:

{
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
    };

  flake.modules.homeManager.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      args = { inherit config pkgs; };
      # Not modules: each evaluates to { text = ''…''; }. The _ keeps import-tree out.
      sections = [
        (import ./niri/_sections/input.nix args)
        (import ./niri/_sections/outputs.nix args)
        (import ./niri/_sections/binds.nix args)
        (import ./niri/_sections/layout.nix args)
        (import ./niri/_sections/animations.nix args)
        (import ./niri/_sections/window-rules.nix args)
        (import ./niri/_sections/startup.nix args)
        (import ./niri/_sections/environment.nix args)
      ];
    in
    {
      programs.niri.config = ''
        // Niri configuration for NixOS — assembled from home/niri/*.nix
      ''
      + lib.concatMapStringsSep "\n\n" (s: s.text) sections;
    };
}
