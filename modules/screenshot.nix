# One capture -> select -> annotate pipeline; each is useless alone.
{ ... }:

{
  flake.modules.homeManager.screenshot =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.grim
        pkgs.slurp
        pkgs.swappy
      ];
    };
}
