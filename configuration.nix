# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
  ];

  # ── Nix ────────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  # ── Boot ───────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Filesytems ─────────────────────────────────────────────────────────────
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/0ca9f5bb-3aa4-4050-8e12-5b69d3296659";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
  };

  # ── Networking ─────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # ── Locale & Time ──────────────────────────────────────────────────────────
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # ── Users ──────────────────────────────────────────────────────────────────
  users.users."juicygoose007" = {
    isNormalUser = true;
    description  = "Jake Turner";
    extraGroups  = [ "networkmanager" "wheel" ];
    packages     = with pkgs; [];
    shell        = pkgs.zsh;
    home         = "/home/juicygoose007"; 
  };

  # ── Display & Wayland ──────────────────────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  programs.niri.enable     = true;
  programs.xwayland.enable = true;

  xdg.portal = {
    enable                = true;
    extraPortals          = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };

  # Enable GNOME desktop environment
  # services.xserver.displayManager.gdm.enable = true;

  # ── Audio ──────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  # ── Programs ───────────────────────────────────────────────────────────────
  programs.nix-index-database.comma.enable = true;

  programs.firefox.enable  = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.zsh.promptInit = "";
  programs.starship.enable = false;

  programs.steam = {
    enable                       = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable      = false;
  };

  # ── System Packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Niri / Wayland (compositor needs these system-wide)
    niri
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    wayland-utils

    # Storage services
    gvfs
    udisks2
    usbutils

    # Polkit agent
    polkit_gnome

    # Theming (GTK apps need these system-wide)
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # ── Polkit ─────────────────────────────────────────────────────────────────
  security.polkit.enable = true;
  # polkit_gnome in systemPackages ships an autostart .desktop file that
  # registers the agent automatically — no extra systemd unit needed.

  # ── FUSE ───────────────────────────────────────────────────────────────────
  # Required for xdg-document-portal to mount /run/user/1000/doc via fusermount3
  programs.fuse.userAllowOther = true;

    fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    d2coding
    font-awesome
  ];


# Enable the udisks2 service for automounting
services.udisks2.enable = true;


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
  system.stateVersion = "26.05"; # Did you read the comment?
}

