# Host-specific config for goosenest (the desktop). Shared settings live in
# modules/nixos/common.nix; this file is only what's unique to this machine.

{
  config,
  pkgs,
  username,
  ...
}:

let
  # Force the DP-1 connector "connected" (it is kernel-disabled via video=DP-1:d
  # so the console/greeter render at DP-2's native 2560x1440). niri runs this at
  # startup — after the greeter — so DP-1 only lights up for the desktop.
  dp1On = pkgs.writeShellScriptBin "dp1-on" ''
    echo on > /sys/class/drm/*-DP-1/status
  '';
in
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/ollama.nix
  ];

  # ── Networking ─────────────────────────────────────────────────────────────
  networking.hostName = "goosenest";

  # ── Boot: multi-monitor console fix ────────────────────────────────────────
  # video=DP-1:d disables DP-1 for the *kernel console* so it can't force the
  # clone down to 1080p; niri re-enables DP-1 itself for the desktop.
  boot.kernelParams = [
    "video=DP-1:d"
    "video=DP-2:2560x1440@60"
  ];

  # ── Filesystems ────────────────────────────────────────────────────────────
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/0ca9f5bb-3aa4-4050-8e12-5b69d3296659";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # Let niri (as juicygoose007) run dp1-on passwordless at startup, so DP-1 is
  # re-enabled only once the desktop is up — keeping the greeter on DP-2 alone.
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

  # ── Gaming ─────────────────────────────────────────────────────────────────
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = false;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  hardware.steam-hardware.enable = true;

  # ── Host packages ──────────────────────────────────────────────────────────
  # DP-1 re-enable helper (see dp1On above; called by niri via sudo).
  environment.systemPackages = [ dp1On ];

  # ── Wooting keyboard ───────────────────────────────────────────────────────
  hardware.wooting.enable = true;

  # ── Ploopy Adept ───────────────────────────────────────────────────────────
  hardware.keyboard.qmk.enable = true;

  # ── Services (optional / commented out) ────────────────────────────────────
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # ── System ─────────────────────────────────────────────────────────────────
  # Records the NixOS version this machine was first installed on — never change
  # it per-host. Kept host-side so each machine owns its own.
  system.stateVersion = "26.05";
}
