{ ... }:

{
  flake.modules.homeManager.brave =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.brave ];

      # brave-browser.desktop declares x-scheme-handler/chromium, not chrome, so
      # the default alone would not resolve.
      xdg.mimeApps = {
        enable = true;
        defaultApplications."x-scheme-handler/chrome" = "brave-browser.desktop";
        associations.added."x-scheme-handler/chrome" = "brave-browser.desktop";
      };
    };
}
