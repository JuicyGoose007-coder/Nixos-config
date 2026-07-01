{ config, pkgs, ... }:

let
  wallpaper = pkgs.runCommand "hyprlock-wallpaper" {
    nativeBuildInputs = [ pkgs.imagemagick ];
  } ''
    convert ${../nixos.png} -filter Gaussian -blur 0x20 $out
  '';
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        monitor     = "";
        path        = "${wallpaper}";
        blur_passes = 0;
        vignette    = true;
      }];

      input-field = [{
        monitor           = "";
        size              = "250, 60";
        outline_thickness = 3;
        outer_color       = "rgb(${config.lib.stylix.colors.base01})";
        inner_color       = "rgb(${config.lib.stylix.colors.base00})";
        font_color        = "rgb(${config.lib.stylix.colors.base06})";
        check_color       = "rgb(${config.lib.stylix.colors.base0D})";
        fail_color        = "rgb(${config.lib.stylix.colors.base08})";
        capslock_color    = "rgb(${config.lib.stylix.colors.base0A})";
        placeholder_text  = "<i>Password...</i>";
        fail_text         = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        rounding          = -1;
        position          = "0, -80";
        halign            = "center";
        valign            = "center";
      }];

      label = [
        {
          monitor     = "";
          text        = ''cmd[update:1000] echo "<b>$(date +"%-I")</b>"'';
          font_size   = 120;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position    = "0, 200";
          halign      = "center";
          valign      = "center";
        }
        {
          monitor     = "";
          text        = ''cmd[update:1000] echo "<b>$(date +"%M")</b>"'';
          font_size   = 120;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position    = "0, 60";
          halign      = "center";
          valign      = "center";
        }
        {
          monitor     = "";
          text        = ''cmd[update:60000] echo "<b>$(date +"%p")</b>"'';
          font_size   = 40;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position    = "120, 60";
          halign      = "center";
          valign      = "center";
        }
        {
          monitor     = "";
          text        = ''cmd[update:60000] echo "<b>$(date +"%A, %B %-d")</b>"'';
          font_size   = 24;
          font_family = "JetBrainsMono Nerd Font";
          position    = "40, -45";
          halign      = "left";
          valign      = "top";
        }
      ];
    };
  };
}
