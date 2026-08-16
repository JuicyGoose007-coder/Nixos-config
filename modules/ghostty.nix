# ghostty — terminal emulator, the one niri spawns at startup.
#
# Font and palette come from stylix's ghostty target, so the toggle lives here.
{ ... }:

{
  flake.modules.homeManager.ghostty =
    { ... }:

    {
      stylix.targets.ghostty.enable = true;

      programs.ghostty = {
        enable = true;
        settings = {
          # Let shift+click through to the application rather than extending the
          # terminal's own selection.
          mouse-shift-capture = true;
        };
      };
    };
}
