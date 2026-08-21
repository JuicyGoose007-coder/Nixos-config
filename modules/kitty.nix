# kitty — terminal emulator. Font and palette come from stylix, which is why
# there is nothing here beyond `enable`.
{ ... }:

{
  flake.modules.homeManager.kitty =
    { ... }:

    {
      programs.kitty = {
        enable = true;
      };
    };
}
