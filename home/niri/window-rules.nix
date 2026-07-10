{ ... }:
{
  text = ''

    // ────────────── Window Rules ──────────────

        window-rule {
            match app-id=r#"firefox$"# title="^Picture-in-Picture$"
            open-floating true // Always float Firefox PiP windows
        }

        window-rule {
            geometry-corner-radius 20 // Set every window radius to 20
            clip-to-geometry true
        }

        window-rule {
            // This regular expression is intentionally made as specific as possible,
            // since this is the default config, and we want no false positives.
            // You can get away with just app-id="wezterm" if you want.
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}
        }

        window-rule {
            match app-id=r#"^org\.gnome\."#
            draw-border-with-background false
            geometry-corner-radius 12
            clip-to-geometry true
        }

        window-rule {
            match app-id=r#"^gnome-control-center$"#
            match app-id=r#"^pavucontrol$"#
            match app-id=r#"^nm-connection-editor$"#
            default-column-width { proportion 0.5; }
            open-floating false
        }

        window-rule {
            match app-id=r#"^gnome-calculator$"#
            match app-id=r#"^galculator$"#
            match app-id=r#"^blueman-manager$"#
            match app-id=r#"^org.kde.dolphin"
            match app-id=r#"^xdg-desktop-portal$"#
            open-floating true
        }

        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            match app-id="ghostty"
            match app-id="com.mitchellh.ghostty"
            match app-id="kitty"
            draw-border-with-background false
        }

        window-rule {
            match is-active=false
            opacity 0.9
        }

        window-rule {
            background-effect {
                blur true
            }
        }

        window-rule {
            match app-id=r#"firefox$"# title="^Picture-in-Picture$"
            match app-id="zoom"
            open-floating true
        }

        window-rule {
            match app-id="org.kde.dolphin"
            open-floating true
        }

        window-rule{
            match app-id=r#"^steam_app_"#
            open-fullscreen true
            open-focused true
            open-on-workspace "Gaming"
        }

        window-rule{
            match title="Steam"
            match app-id="steam"
            default-column-width { proportion 0.5; }
            open-maximized true
            open-focused false
            open-on-workspace "Gaming"
        }

        window-rule{
            match app-id=r#"^steam$"#
            default-column-width { proportion 0.5; }
            open-focused false
            open-on-workspace "Gaming"
            open-fullscreen false
            open-maximized true
        }

        window-rule{
          match title="Via"
          match app-id="via-nativia"
          open-on-output "DP-1"
        }

        window-rule{
          match title="Battle.net"
            match app-id="steam_app_0"
            default-column-width { proportion 0.5; }
            open-focused false
            open-on-workspace "Gaming"
        }

        window-rule{
          match title="Battle.net Login"
            match app-id="steam_app_0"
            default-column-width { proportion 0.5; }
            open-focused false
            open-on-workspace "Gaming"
        }

        window-rule{
            match title="ghostty"
            match app-id="com.mitchellh.ghostty"
            open-fullscreen false
            open-focused true
            default-column-width { proportion 0.5; }
            opacity 0.9
        }

        window-rule{
            match title="kitty"
            match app-id="kitty"
            open-fullscreen false
            open-focused true
            default-column-width { proportion 0.5; }
            opacity 0.9
        }

        window-rule{
            match title="vesktop"
            match app-id="vesktop"
            open-on-output "DP-1"
            open-on-workspace "Discord"
            open-maximized true
            opacity 0.9
        }

        window-rule{
            match title="Solaar"
            match app-id="solaar"
            open-on-output "DP-1"
            open-on-workspace "Discord"
            opacity 0.9
        }

        window-rule{
            match app-id="gamescope"
            open-fullscreen true
            open-on-workspace "Gaming"
            open-focused true
        }

        window-rule{
            match app-id="org.kde.kdevelop"
            open-focused true
            open-maximized true
            opacity 0.9

        }
  '';
}
