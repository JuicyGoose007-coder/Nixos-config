# Dual-monitor setup. DP-1 is kernel-disabled at boot so the console and greeter
# render at DP-2's native 2560x1440 instead of cloning down to 1080p; niri
# re-enables it once the desktop is up, by spawning dp1-on through sudo from
# modules/niri/_sections/startup.nix.
{ ... }:

{
  flake.modules.nixos.monitors =
    { pkgs, username, ... }:

    let
      dp1On = pkgs.writeShellScriptBin "dp1-on" ''
        echo on > /sys/class/drm/*-DP-1/status
      '';
    in
    {
      boot.kernelParams = [
        "video=DP-1:d"
        "video=DP-2:2560x1440@60"
      ];

      environment.systemPackages = [ dp1On ];

      security.sudo.extraRules = [
        {
          users = [ username ];
          commands = [
            {
              command = "/run/current-system/sw/bin/dp1-on";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
