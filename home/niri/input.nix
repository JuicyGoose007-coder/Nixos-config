{ ... }:
{
  text = ''

   // ────────────── Input Configuration ──────────────

    input {
        keyboard {
            xkb {
                layout "us" // Use the German keyboard layout
            }
            numlock // Enable numlock on startup
        }

        touchpad {
            tap // Enable tap-to-click
            natural-scroll // Enable natural (macOS-style) scrolling
        }

        focus-follows-mouse // Automatically focus windows under the mouse pointer
        warp-mouse-to-focus // Moves mouse to window that is focused
        workspace-auto-back-and-forth // Enable workspace back & forth switching
    }
  '';
}
