{ pkgs, ... }:
{
  text = ''

    // ────────────── Startup Applications ──────────────

    spawn-sh-at-startup "systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP && systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gnome.service"

    spawn-sh-at-startup "waybar"
    spawn-sh-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-sh-at-startup "awww-daemon" // Wallpaper daemon
    spawn-sh-at-startup "hyprlock --daemonize"
    spawn-sh-at-startup "steam -no-browser"
    spawn-sh-at-startup "vesktop"
    // Turn on DP-1
    spawn-sh-at-startup "sudo -n /run/current-system/sw/bin/dp1-on; sleep 1; niri msg output DP-1 on"
    spawn-sh-at-startup "niri msg action focus-workspace Main"

        prefer-no-csd // Disable program decorations
        //screenshot-path null // Disable screenshot saving
        screenshot-path "~/Pictures/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
  '';
}
