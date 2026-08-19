# stylix — system-wide theming: the base16 palette, the wallpaper, and the fonts,
# plus the per-application targets on the home-manager side.
#
# The fourth aspect converted to the dendritic pattern, and the first to pull in
# its own flake input. Until now `inputs.stylix.nixosModules.stylix` and the
# disabledModules below sat in the module list in modules/hosts.nix, which meant
# the host builder had to know this topic exists and where its upstream module
# comes from. It does not any more — the aspect imports its own dependency, and
# mkHost picks the whole registry up by name.
#
# The option `flake.modules.<class>.<name>` is declared by modules/aspects.nix.
#
# The NixOS half moved verbatim from system/stylix.nix and the home-manager half
# from the stylix block in home/default.nix: one topic that used to be spread
# across two trees *and* the host builder. `../wallpapers/…` resolves to the same
# path from modules/ as it did from system/ (both are one level under the flake
# root), so the image path needed no adjustment — the same free ride
# `../dots/zshrc` got in the zsh move.
{ inputs, ... }:

{
  flake.modules.nixos.stylix =
    # Ordinary NixOS module from here down. `inputs` is captured from the outer
    # flake-parts scope by closure — it is not an argument of this function,
    # whose args are the NixOS ones.
    { pkgs, ... }:

    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      # Inherited from the pre-dendritic config: kmscon has been disabled since
      # the repo's initial commit and regreet was added some time after, but
      # neither reason was ever recorded in a commit message or a comment. Kept
      # as-is because this move is meant to be behaviour-neutral; finding out
      # whether they are still needed is a separate experiment.
      disabledModules = [
        "${inputs.stylix}/modules/kmscon/nixos.nix"
        "${inputs.stylix}/modules/regreet/nixos.nix"
      ];

      stylix = {
        enable = true;
        image = ../wallpapers/sushi.jpg;

        base16Scheme = {
          scheme = "Gruvbox Dark";
          author = "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)";
          base00 = "282828";
          base01 = "3c3836";
          base02 = "504945";
          base03 = "665c54";
          base04 = "bdae93";
          base05 = "d5c4a1";
          base06 = "ebdbb2";
          base07 = "fbf1c7";
          base08 = "fb4934";
          base09 = "fe8019";
          base0A = "fabd2f";
          base0B = "b8bb26";
          base0C = "8ec07c";
          base0D = "83a598";
          base0E = "d3869b";
          base0F = "d65d0e";
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
      # Retry the image call itself rather than polling a proxy for readiness.
      # Two things have to be true before `awww img` works, and they do not
      # become true together: the daemon's socket comes up almost immediately,
      # but niri advertises its outputs a beat later. An earlier version polled
      # `awww query` — which only proves the socket is live — and so ran `img`
      # too early, got "none of the requested outputs are valid", failed
      # ExecStartPost, and took the whole unit down for a full RestartSec.
      #
      # Errors are silenced because the loop would otherwise write one to the
      # journal every 200ms. The backstop is systemd's TimeoutStartSec (90s by
      # default): if the outputs genuinely never arrive, the unit fails there.
      setWallpaper = pkgs.writeShellScript "awww-set-wallpaper" ''
        until ${pkgs.awww}/bin/awww img ${config.stylix.image} >/dev/null 2>&1; do
          sleep 0.2
        done
      '';
    in
    {
      # The wallpaper daemon belongs to this aspect rather than to niri: the image
      # it displays is stylix.image, so the topic owns both halves. It used to be
      # a `spawn-sh-at-startup "awww-daemon"` line in home/niri/startup.nix that
      # never said *which* image — the wallpaper was set by hand and survived only
      # in awww's runtime state, which is what this replaces.
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

      # Targets for topics that are still legacy home/ modules. Each moves into
      # its own aspect as that topic migrates — waybar, kitty, and ghostty
      # already have.
      stylix.targets.fzf.enable = true;
      stylix.targets.starship.enable = true;
      stylix.targets.tmux.enable = true;
      stylix.targets.hyprlock.enable = false;
      stylix.targets.neovim.enable = false;
    };
}
