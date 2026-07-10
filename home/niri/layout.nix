{ config, ... }:
{
  text = ''
    // ────────────── Layout Settings ──────────────

        layout {
            gaps 10 // Gap between windows
            always-center-single-column
            center-focused-column "never" // Don't auto-center focused column

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            focus-ring {
                width 3
                active-color "#${config.lib.stylix.colors.base08}"
                inactive-color "#${config.lib.stylix.colors.base02}"
            }

            shadow {
                softness 30
                spread 5
                offset x=0 y=5
                color "#0007"
            }

            struts {}
        }

    // ────────────── Animation Settings ──────────────

        animations {
            workspace-switch {
                spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
            }
            window-open {
                duration-ms 200
                curve "ease-out-quad"
            }
            window-close {
                duration-ms 200
                curve "ease-out-cubic"
            }
            horizontal-view-movement {
                spring damping-ratio=1.0 stiffness=900 epsilon=0.0001
            }
            window-movement {
                spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
            }
            window-resize {
                spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
            }
            config-notification-open-close {
                spring damping-ratio=0.6 stiffness=1200 epsilon=0.001
            }
            screenshot-ui-open {
                duration-ms 300
                curve "ease-out-quad"
            }
            overview-open-close {
                spring damping-ratio=1.0 stiffness=900 epsilon=0.0001
            }
        }
  '';
}
