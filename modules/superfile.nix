# superfile — terminal file manager.
#
# Builds superfile itself: nixpkgs is pinned at 1.3.3 while upstream is on 1.6.0,
# so the package half lives here too.
{ withSystem, ... }:

{
  # `nix build /etc/nixos#superfile` builds this directly, same as nx.
  perSystem =
    { pkgs, lib, ... }:
    let
      version = "1.6.0";
      tag = "v${version}";
    in
    {
      packages.superfile = pkgs.buildGoModule {
        pname = "superfile";
        inherit version;

        src = pkgs.fetchFromGitHub {
          owner = "yorukot";
          repo = "superfile";
          inherit tag;
          hash = "sha256-JETdQ42vGPnpviCAR29BSdBTG+huWRr5syN5NysnAlo=";
        };

        vendorHash = "sha256-d2Yo8fWJ2fj7RJrnktljY6TkEPq6Tnbdh2BM4DIAr0E=";

        ldflags = [
          "-s"
          "-w"
        ];

        nativeBuildInputs = [ pkgs.exiftool ];

        # zoxide is not in nixpkgs' 1.3.3 expression, but 1.6.0's test suite shells
        # out to it across several packages — supplying it beats skipping them all.
        nativeCheckInputs = [
          pkgs.writableTmpDirAsHomeHook
          pkgs.zoxide
        ];

        # Both fail on the build sandbox rather than on the code:
        #   TestReturnDirElement — flaky date sort, nixpkgs skips it too
        #   TestLayout           — asserts on a populated $HOME; ours is empty
        # Go splits -skip on "/" and matches each element, so these are top-level
        # names; only one -skip flag is honoured, hence the single alternation.
        checkFlags = [
          "-skip=^(TestReturnDirElement|TestLayout)$"
        ];

        meta = {
          description = "Pretty fancy and modern terminal file manager";
          homepage = "https://github.com/yorukot/superfile";
          changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
          license = lib.licenses.mit;
          mainProgram = "superfile";
        };
      };
    };

  flake.modules.homeManager.superfile =
    # From here down this is an ordinary home-manager module. Note `config` is the
    # *home-manager* config — not the flake-parts config the outer file would see.
    { config, pkgs, ... }:
    let
      # Stylix exposes the active base16 palette here (same accessor used in
      # modules/niri/_sections/layout.nix). Values are bare hex ("ebdbb2"), so prefix "#".
      colors = config.lib.stylix.colors;
      c = base: "#${colors.${base}}";
    in
    {
      programs.superfile = {
        enable = true;

        # Reach the package built by `perSystem` above. `withSystem` stays inside
        # this flake-parts evaluation rather than routing through inputs.self, so
        # it can't become a self-reference. The `config` in the callback is a
        # third one: the perSystem config, not home-manager's and not the flake's.
        package = withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.superfile);

        settings = {
          theme = "stylix";
          ignore_missing_fields = true;
        };

        # Stylix has no superfile target, so we hand-roll a theme wired to the
        # base16 palette. Field names come from superfile's theme schema:
        # https://superfile.dev/configure/custom-theme/
        themes.stylix = {
          # Chroma style for file previews — not part of base16, kept static.
          code_syntax_highlight = "gruvbox";

          # Full screen
          full_screen_fg = c "base05";
          full_screen_bg = c "base00";

          # Gradient (two accent colors)
          gradient_color = [
            (c "base0B")
            (c "base0C")
          ];
          directory_icon_color = c "base0C";

          # File panel
          file_panel_fg = c "base05";
          file_panel_bg = c "base00";
          file_panel_border = c "base03";
          file_panel_border_active = c "base0D";
          file_panel_top_directory_icon = c "base0C";
          file_panel_top_path = c "base0D";
          file_panel_item_selected_fg = c "base0A";
          file_panel_item_selected_bg = c "base02";

          # Footer
          footer_fg = c "base05";
          footer_bg = c "base00";
          footer_border = c "base03";
          footer_border_active = c "base0D";

          # Sidebar
          sidebar_fg = c "base05";
          sidebar_bg = c "base00";
          sidebar_title = c "base0B";
          sidebar_border = c "base00";
          sidebar_border_active = c "base0D";
          sidebar_item_selected_fg = c "base09";
          sidebar_item_selected_bg = c "base02";
          sidebar_divider = c "base03";

          # Modals
          modal_fg = c "base05";
          modal_bg = c "base00";
          modal_border_active = c "base03";
          modal_cancel_fg = c "base05";
          modal_cancel_bg = c "base03";
          modal_confirm_fg = c "base00";
          modal_confirm_bg = c "base0B";

          # Help menu
          help_menu_hotkey = c "base0C";
          help_menu_title = c "base0D";

          # Special
          cursor = c "base0D";
          correct = c "base0B";
          error = c "base08";
          hint = c "base0D";
          cancel = c "base04";
        };
      };
    };
}
