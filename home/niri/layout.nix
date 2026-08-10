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

  '';
}
