# Removable-media mounting. gvfs is what makes it reachable from the file
# managers rather than a program in its own right.
{ ... }:

{
  flake.modules.nixos.udisks2 =
    { pkgs, ... }:
    {
      services.udisks2.enable = true;

      environment.systemPackages = [
        pkgs.gvfs
        # lsusb — the USB-side diagnostic for the same job, and system-wide as
        # it was before.
        pkgs.usbutils
      ];
    };
}
