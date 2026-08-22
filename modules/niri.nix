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

      # xwayland-satellite is niri's X11 bridge specifically, not a generic
      # system package.
      programs.xwayland.enable = true;
      environment.systemPackages = [ pkgs.xwayland-satellite ];
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
      # Session tools, not shell tools: wl-clipboard is what makes nvim's
      # clipboard=unnamedplus work here.
      home.packages = [
        pkgs.wl-clipboard
        pkgs.wlr-randr
        pkgs.wayland-utils
      ];

      programs.niri.config = ''
        // Niri configuration for NixOS — assembled from home/niri/*.nix
      ''
      + lib.concatMapStringsSep "\n\n" (s: s.text) sections;
    };
}
