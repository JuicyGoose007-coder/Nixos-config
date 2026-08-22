{ ... }:

{
  flake.modules.nixos.firefox =
    { ... }:
    {
      programs.firefox.enable = true;
    };

  flake.modules.homeManager.firefox =
    { ... }:
    let
      handlers = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
    in
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = handlers;
        associations.added = handlers;
      };
    };
}
