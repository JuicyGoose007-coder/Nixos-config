{ ... }:

{
  flake.modules.homeManager.claude-code =
    { ... }:
    {
      programs.claude-code.enable = true;

      xdg.mimeApps = {
        enable = true;
        defaultApplications."x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
    };
}
