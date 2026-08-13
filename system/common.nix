{
  config,
  pkgs,
  username,
  ...
}:
{
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

  networking.networkmanager.enable = true;

  # ── Locale & Time ──────────────────────────────────────────────────────────
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ── Users ──────────────────────────────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = "Jake Turner";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
    ];
    shell = pkgs.zsh;
    home = "/home/${username}";
  };

  # ── Display & Wayland ──────────────────────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    # Route ScreenCast/Screenshot to the gnome backend (niri implements
    # org.gnome.Mutter.ScreenCast, so screen sharing goes through it); use gtk
    # for native file-picker dialogs.
    config.common = {
      default = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  # ── Display manager: greetd + tuigreet (native Wayland) ────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd "env XDG_SESSION_DESKTOP=niri XDG_CURRENT_DESKTOP=niri XDG_SESSION_CLASS=user niri-session"'';
        user = "greeter";
      };
    };
  };

  # ── Audio ──────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ── Programs ───────────────────────────────────────────────────────────────
  programs.nix-index-database.comma.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.zsh.promptInit = "";

  # ── System Packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Niri / Wayland (compositor needs these system-wide)
    xwayland-satellite

    # Storage services
    gvfs
    usbutils

    # Polkit agent
    polkit_gnome

    # Theming (GTK apps need these system-wide)
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # ── Polkit ─────────────────────────────────────────────────────────────────
  security.polkit.enable = true;

  # ── FUSE ───────────────────────────────────────────────────────────────────
  # Required for xdg-document-portal to mount /run/user/1000/doc via fusermount3
  programs.fuse.userAllowOther = true;

  # ── Fonts ──────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    d2coding
    font-awesome
  ];

  services.udisks2.enable = true;

  # ── Docker ─────────────────────────────────────────────────────────────────
  virtualisation.docker.enable = true;
}
