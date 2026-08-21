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
        image = ../wallpapers/forest.jpg;

        # Names are upstream's, from https://github.com/sainnhe/everforest
        # palette.md. base06/base07 come from Light Soft: the dark palette has
        # nothing above fg to fill base16's two lightest slots.
        base16Scheme = {
          scheme = "Everforest Dark Soft";
          author = "Sainnhe Park (https://github.com/sainnhe)";
          base00 = "333c43"; # bg0
          base01 = "3a464c"; # bg1
          base02 = "4d5960"; # bg3
          base03 = "859289"; # grey1
          base04 = "9da9a0"; # grey2
          base05 = "d3c6aa"; # fg
          base06 = "ddd8be"; # light bg3
          base07 = "f3ead3"; # light bg0
          base08 = "e67e80"; # red
          base09 = "e69875"; # orange
          base0A = "dbbc7f"; # yellow
          base0B = "a7c080"; # green
          base0C = "83c092"; # aqua
          base0D = "7fbbb3"; # blue
          base0E = "d699b6"; # purple
          base0F = "9da9a0"; # grey2
        };

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
      };
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
          # Same guards home-manager's own hyprpaper service uses: don't start
          # without a compositor, and die with the session rather than linger.
          ConditionEnvironment = "WAYLAND_DISPLAY";
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = "${pkgs.awww}/bin/awww-daemon";
          ExecStartPost = "${setWallpaper}";
          Restart = "always";
          RestartSec = "10";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      stylix.enableReleaseChecks = false;

      stylix.targets.neovim.enable = false;
    };
}
