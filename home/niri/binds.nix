{ ... }:
{
  text = ''


    // ────────────── Keybindings ──────────────

    binds {

        // ─── Applications ───
        MOD+RETURN                          hotkey-overlay-title="Open Terminal: ghostty" { spawn-sh "ghostty"; }
        MOD+D                               hotkey-overlay-title="Open App Launcher: rofi" { spawn-sh "/etc/nixos/dots/rofi/launchers/type-6/launcher.sh"; }
        MOD+B                               hotkey-overlay-title="Open Browser: firefox" { spawn-sh "firefox"; }
        MOD+O                               hotkey-overlay-title="Open Browser: brave" { spawn-sh "brave"; }
        MOD+ALT+L                           hotkey-overlay-title="Lock Screen: hyprlock" { spawn-sh "hyprlock"; }
        MOD+T                               hotkey-overlay-title="Toggle Opacity" { toggle-window-rule-opacity; }
        MOD+ALT+P                           hotkey-overlay-title="Open Power Menu" { spawn-sh "$HOME/.config/rofi/scripts/powermenu_t2"; }

        // ─── Waybar ───
        MOD+ALT+R                           hotkey-overlay-title="Launch Waybar" { spawn-sh "/etc/nixos/scripts/waybar.sh"; }
        

        // Please choose your own file manager
        MOD+E                             hotkey-overlay-title="File Manager: Dolphin" { spawn-sh "dolphin"; }
        MOD+Y                               hotkey-overlay-title="Open File Manager: Yazi"{ spawn "ghostty" "-e" "zsh" "-ic" "yazi"; }

        // ─── Audio Controls ───
        // Example volume keys mappings for PipeWire & WirePlumber.
        // The allow-when-locked=true property makes them work even when the session is locked.
        XF86AudioRaiseVolume                allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
        XF86AudioLowerVolume                allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute                       allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute                    allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
        XF86AudioNext                       allow-when-locked=true { spawn-sh "playerctl next"; }
        XF86AudioPause                      allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioPlay                       allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioPrev                       allow-when-locked=true { spawn-sh "playerctl previous"; }

        // === Window Management ===
        Mod+Q repeat=false { close-window; }
        Mod+Shift+Q repeat=false  { spawn-sh "pkill -SIGKILL -f pressure-vessel; pkill -SIGKILL reaper; pkill gamescope"; }
        Mod+Shift+F { maximize-column; }
        Mod+F { fullscreen-window; }
        Mod+Shift+T { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+W { toggle-column-tabbed-display; }

        // === Focus Navigation ===
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        // === Window Movement ===
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        // === Column Navigation ===
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        // === Monitor Navigation ===
        Mod+Ctrl+Left  { focus-monitor-left; }
        //Mod+Ctrl+Down  { focus-monitor-down; }
        //Mod+Ctrl+Up    { focus-monitor-up; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        // === Move to Monitor ===
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        // === Workspace Navigation ===
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+Ctrl+Down { move-column-to-workspace-down; }
        Mod+Ctrl+Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }

        // === Move Workspaces ===
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }

        // === Mouse Wheel Navigation ===
        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }


        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        // === Named Workspaces ===
        Mod+G { focus-workspace "Gaming"; }
        Mod+M { focus-workspace "Main"; }
        Mod+I { focus-workspace "Discord"; }
        Mod+N { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }

        // === Move to Named Workspaces ===
        Mod+Shift+G { move-column-to-workspace "Gaming"; }
        Mod+Shift+M { move-column-to-workspace "Main"; }
        Mod+Shift+I { move-column-to-workspace "Discord"; }
        Mod+Shift+N { move-column-to-workspace-down; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // === Column Management ===
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Period { expel-window-from-column; }

        // === Sizing & Layout ===
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }

        // === Manual Sizing ===
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // ─── Screenshots ───
        CTRL+P                        { screenshot; }
        CTRL+SHIFT+P                        { screenshot-screen; }
        CTRL+SHIFT+W                        { screenshot-window; }

        // ─── Emergency Escape Key ───
        // Use this when a fullscreen app blocks your keybinds.
        // It disables any active keyboard shortcut inhibitor, restoring control.
        MOD+ESCAPE                          allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // ─── Exit / Power ───
        CTRL+ALT+DELETE                     { quit; } // Also quits Niri
        MOD+SHIFT+P                         { power-off-monitors; } // Turn off screens (useful for OLED or privacy)
        Mod+Space { spawn "niri" "msg" "action" "toggle-overview"; }
    }
  '';
}
