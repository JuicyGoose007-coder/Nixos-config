# kitty — terminal emulator.
#
# Everything beyond `enable` comes from stylix's kitty target (font and palette),
# which is why the toggle lives here rather than in modules/stylix.nix.
{ ... }:

{
  flake.modules.homeManager.kitty =
    { ... }:

    {
      stylix.targets.kitty.enable = true;

      programs.kitty = {
        enable = true;
      };
    };
}
