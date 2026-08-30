{ inputs, ... }:

{
  flake.modules.nixos.stylix =
    # Ordinary NixOS module from here down. `inputs` is captured from the outer
    # flake-parts scope by closure — it is not an argument of this function,
    # whose args are the NixOS ones.
    { pkgs, ... }:

    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      disabledModules = [
        "${inputs.stylix}/modules/kmscon/nixos.nix"
        "${inputs.stylix}/modules/regreet/nixos.nix"
      ];

      stylix = {
        enable = true;
        image = ../wallpapers/sushi.jpg;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
          sansSerif = {
            package = pkgs.inter;
            name = "Inter";
          };
          sizes.terminal = 12;
          sizes.applications = 11;
        };

        cursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 20;
        };
      };

      fonts.packages = with pkgs; [
        fira-code
        jetbrains-mono
        d2coding
        font-awesome
      ];

      # GTK apps resolve these system-wide, not from the user profile.
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnome-themes-extra
      ];
    };

  # The home-manager half. Nothing is imported here: the NixOS module above
  # injects stylix's home-manager module into home-manager.sharedModules itself,
  # so these are only option assignments.
  flake.modules.homeManager.stylix =
    { config, pkgs, ... }:

    let
      setWallpaper = pkgs.writeShellScript "awww-set-wallpaper" ''
        until ${pkgs.awww}/bin/awww img ${config.stylix.image} >/dev/null 2>&1; do
          sleep 0.2
        done
      '';
    in
    {
      # Wallpaper daemon
      home.packages = [ pkgs.awww ];

      systemd.user.services.awww = {
        Unit = {
          Description = "awww wallpaper daemon";
          ConditionEnvironment = "WAYLAND_DISPLAY";
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStartPre = "${pkgs.coreutils}/bin/rm -rf %C/awww";
          ExecStart = "${pkgs.awww}/bin/awww-daemon";
          ExecStartPost = "${setWallpaper}";
          Restart = "always";
          RestartSec = "10";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      stylix.enableReleaseChecks = false;
    };
}
