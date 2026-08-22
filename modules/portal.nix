{ ... }:

{
  flake.modules.nixos.portal =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
        ];
        # Route ScreenCast/Screenshot to the gnome backend (niri implements
        # org.gnome.Mutter.ScreenCast, so screen sharing goes through it); use gtk
        # for native file-picker dialogs.
        config.common = {
          default = [ "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };

      # Required for xdg-document-portal to mount /run/user/1000/doc via fusermount3
      programs.fuse.userAllowOther = true;
    };
}
