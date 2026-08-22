# Only the keymap and the X server scaffolding niri's XWayland path needs.
# niri sets its own xkb layout in modules/niri/_sections/input.nix; this is
# what the console and any X client see.
{ ... }:

{
  flake.modules.nixos.xserver =
    { ... }:
    {
      services.xserver.enable = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
}
