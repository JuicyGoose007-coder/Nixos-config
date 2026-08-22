{ inputs, ... }:

{
  flake.modules.homeManager.zen =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "zen.desktop";
          "application/xhtml+xml" = "zen.desktop";
          "x-scheme-handler/http" = "zen.desktop";
          "x-scheme-handler/https" = "zen.desktop";
        };
      };
    };
}
