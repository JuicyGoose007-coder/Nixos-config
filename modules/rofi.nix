# rofi — application launcher and power menu.
#
# The .rasi layout files stay under dots/ as upstream theme data, but their
# palette is generated here from stylix, so a base16Scheme change repaints both
# menus. recursive is what lets the generated file land inside the tree.
{ ... }:

{
  flake.modules.homeManager.rofi =
    { config, pkgs, ... }:

    let
      c = config.lib.stylix.colors;
      inherit (config.stylix.fonts) monospace sizes;
    in
    {
      home.packages = [ pkgs.rofi ];

      xdg.configFile."rofi" = {
        source = ../dots/rofi;
        recursive = true;
      };

      xdg.configFile."rofi/colors/stylix.rasi".text = ''
        * {
            font:            "${monospace.name} ${toString sizes.popups}";
            background:      #${c.base00}FF;
            background-alt:  #${c.base01}FF;
            foreground:      #${c.base05}FF;
            selected:        #${c.base0D}FF;
            active:          #${c.base0B}FF;
            urgent:          #${c.base08}FF;
        }
      '';
    };
}
