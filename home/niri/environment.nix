{ ... }:
{
  text = ''
    // ────────────── Environment Variables ──────────────

        environment {
            DISPLAY ":1"
            ELECTRON_OZONE_PLATFORM_HINT "auto"
            QT_QPA_PLATFORM "wayland"
            QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
            XDG_SESSION_TYPE "wayland"
            XDG_CURRENT_DESKTOP "niri"
            COLORTERM "truecolor"
            TERM "xterm-256color"
        }

        hotkey-overlay {
            skip-at-startup
        }

        workspace "Gaming"{
            open-on-output "DP-2"
        }

        workspace "Main"{
            open-on-output "DP-2"
        }

        workspace "Discord"{
            open-on-output "DP-1"
        }

        blur {
            passes 4
            offset 0.75
        }
  '';
}
