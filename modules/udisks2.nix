# Removable-media mounting. gvfs is what makes it reachable from the file
# managers rather than a program in its own right; the module, not the bare
# package, is what puts its GIO module on GIO_EXTRA_MODULES — without that
# nothing can open trash:// or network://.
{ ... }:

{
  flake.modules.nixos.udisks2 =
    { pkgs, ... }:
    {
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      # The default is the fuller gnome build, which drags in
      # gnome-online-accounts and libmsgraph for backends nothing here uses.
      services.gvfs.package = pkgs.gvfs;

      environment.systemPackages = [
        # lsusb — the USB-side diagnostic for the same job, and system-wide as
        # it was before.
        pkgs.usbutils
      ];
    };
}
