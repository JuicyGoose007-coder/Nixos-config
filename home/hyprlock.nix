{ config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        monitor     = "";
        path        = "../sushi.jpg";
        blur_passes = 1;
        blur_size   = 5;
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
          text        = ''cmd[update:1000] echo "<b>$(date +"%H")</b>"'';
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
      ];
    };
  };
}
