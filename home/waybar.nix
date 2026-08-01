{ ... }:

{
  programs.waybar = {
    enable = true;
    settings = [
      {
        position = "bottom";
        layer = "top";
        margin-bottom = 13;

        modules-center = [
          "niri/workspaces"
          "clock"
        ];

        "clock" = {
          timezone = "America/New_York";
          locale = "en_US.UTF-8";
          format = "{:%I:%M %p}";
          interval = 60;
        };

        "niri/workspaces" = {
          format = "{name}: {icon}";
          active-only = true;
          format-icons = {
            Main = "";
            Discord = "󰙯";
            Gaming = "󰸴";
            "1" = "⚀";
            "2" = "⚁";
            "3" = "⚂";
            "4" = "⚃";
            "5" = "⚄";
            "6" = "⚅";
            active = "●";
            default = "○";
          };
        };
      }
    ];

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

      /* The single centered pill — holds workspaces + clock */
      .modules-center {
        background: @base01;
        border: 1px solid @base02;
        border-radius: 50px;
        padding: 0 16px;
      }

      /* Modules read as one continuous pill: no own background */
      #clock,
      #workspaces {
        background: transparent;
        color: @base09;
        padding: 0 8px;
      }

      #workspaces button {
        padding: 0px 6px;
        margin: 0px 3px;
        border-radius: 50px;
        color: @base09;
        transition: all 0.3s ease-in-out;
        background-color: transparent;
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
    '';
  };
}
