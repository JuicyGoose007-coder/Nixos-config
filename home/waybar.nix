{ ... }:

{
  programs.waybar = {
    enable   = true;
    settings = [{
      position     = "bottom";
      layer        = "top";
      margin-bottom = 13;

      modules-left   = [ "niri/workspaces" ];
      modules-center = [ "custom/notification" ];
      modules-right  = [ "clock" "wireplumber" ];

      "clock" = {
        timezone = "America/New_York";
        locale   = "en_US.UTF-8";
        format   = "{:%I:%M %p}";
        interval = 60;
      };

      "niri/workspaces" = {
        format       = "{name}: {icon}";
        active-only  = true;
        format-icons = {
          Main    = "";
          Discord = "󰙯";
          Gaming  = "󰸴";
          "1"     = "①";
          "2"     = "②";
          "3"     = "③";
          active  = "●";
          default = "○";
        };
      };

      "wireplumber" = {
        format         = "{icon} {volume}%";
        format-muted   = "󰖁 muted";
        tooltip-format = "Volume: {volume}%";
        on-click       = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "ghostty -e wiremix";
        on-scroll-up   = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        format-icons   = [ "󰕿" "󰖀" "󰕾" ];
      };

      "custom/notification" = {
        tooltip      = true;
        format       = "<span size='16pt'>{icon}</span>";
        format-icons = {
          notification          = "󱅫";
          none                  = "󰂜";
          dnd-notification      = "󰂠";
          dnd-none              = "󰪓";
          inhibited-notification = "󰂛";
          inhibited-none        = "󰪑";
          dnd-inhibited-notification = "󰂛";
          dnd-inhibited-none    = "󰪑";
        };
        return-type = "json";
        exec-if     = "which swaync-client";
        exec        = "swaync-client -swb";
        on-click       = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape      = true;
      };
    }];

    # Stylix prepends @define-color base00..base0F — referenced below
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font Propo";
        font-weight: bold;
        font-size: 1.2rem;
        min-height: 0;
        border-radius: 50px;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: @base00;
        border: 1px solid @base03;
      }

      tooltip label {
        color: @base05;
      }

      .modules-center {
        margin-right: 15px;
        margin-left: 15px;
      }

      .modules-left {
        margin-left: 15px;
      }

      .modules-right {
        margin-right: 15px;
      }

      #custom-launcher,
      #clock,
      #workspaces,
      #custom-notification,
      #custom-media,
      #custom-pacman,
      #wireplumber {
        background: @base01;
        border: 1px solid @base02;
        color: @base09;
        margin-right: 10px;
        padding: 0 10px;
      }

      #workspaces button {
        padding: 0px 6px;
        margin: 0px 3px;
        border-radius: 50px;
        color: @base09;
        transition: all 0.3s ease-in-out;
        background-color: @base02;
      }

      #workspaces button.active {
        background-color: @base08;
        color: @base00;
        min-width: 50px;
        transition: all 0.3s ease-in-out;
        font-size: 13px;
        border-radius: 5px;
        border-bottom: none;
      }

      #workspaces button:hover {
        background-color: @base03;
        color: @base06;
        border-radius: 16px;
        min-width: 50px;
      }

      #workspaces button.urgent {
        background-color: @base08;
        color: @base00;
        border-radius: 16px;
        min-width: 50px;
        transition: all 0.3s ease-in-out;
      }

      #custom-notification:hover {
        background-color: @base09;
        color: @base00;
      }
    '';
  };
}
