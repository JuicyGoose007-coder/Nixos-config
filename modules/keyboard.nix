# Wooting keyboard and the Ploopy Adept trackball, plus via — the GUI that
# configures the boards these udev rules make writable.
{ ... }:

{
  flake.modules.nixos.keyboard =
    { ... }:
    {
      hardware.wooting.enable = true;
      hardware.keyboard.qmk.enable = true;
    };

  flake.modules.homeManager.keyboard =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.via
        pkgs.vial
      ];

      # wootility.desktop comes from hardware.wooting.enable above, system-side.
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/wootwoot" = "wootility.desktop";
          "x-scheme-handler/web+wootwoot" = "wootility.desktop";
        };
      };
    };
}
