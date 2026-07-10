{ config, lib, pkgs, ... }:
let
  args = { inherit config pkgs; };
  sections = [
    (import ./input.nix        args)
    (import ./outputs.nix      args)
    (import ./binds.nix        args)
    (import ./layout.nix       args)
    (import ./window-rules.nix args)
    (import ./startup.nix      args)
    (import ./environment.nix  args)
  ];
in
{
  xdg.configFile."niri/config.kdl" = {
    force = true;
    text = ''
      // Niri configuration for NixOS — assembled from home/niri/*.nix
    '' + lib.concatMapStringsSep "\n\n" (s: s.text) sections;
  };
}
