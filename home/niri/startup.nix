{ pkgs, ... }:
{
  text = ''

    // ────────────── Startup Applications ──────────────

    spawn-sh-at-startup "waybar"
    spawn-sh-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-sh-at-startup "awww-daemon" // Wallpaper daemon
    spawn-sh-at-startup "xwayland-satellite :1"
    spawn-sh-at-startup "hyprlock --daemonize"
    spawn-sh-at-startup "steam -no-browser"
    spawn-sh-at-startup "vesktop"
    // Re-enable DP-1 once the desktop is up. The kernel disables it via
    // `video=DP-1:d` so the greeter renders on DP-2 at native 2560x1440; this
    // forces the connector back so niri drives DP-1 (dp1-on is NOPASSWD sudo).
    spawn-sh-at-startup "sudo -n /run/current-system/sw/bin/dp1-on; sleep 1; niri msg output DP-1 on"
    spawn-sh-at-startup "niri msg action focus-workspace Main"

        prefer-no-csd // Disable program decorations
        //screenshot-path null // Disable screenshot saving
        screenshot-path "~/Pictures/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
  '';
}
