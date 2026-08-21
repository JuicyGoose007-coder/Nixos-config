# ghostty — terminal emulator, the one niri spawns at startup. Font and palette
# come from stylix.
{ ... }:

{
  flake.modules.homeManager.ghostty =
    { ... }:

    {
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
