# Bootloader and kernel. Host-specific kernel *parameters* stay in the host
# file — this is only what every machine shares.
{ ... }:

{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
