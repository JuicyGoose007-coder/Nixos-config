{ config, ... }:

let
  # Stylix exposes the active base16 palette here (same accessor used in
  # home/niri/layout.nix). Values are bare hex ("ebdbb2"), so prefix "#".
  colors = config.lib.stylix.colors;
  c = base: "#${colors.${base}}";
in
{
  programs.superfile = {
    enable = true;

    settings.theme = "stylix";

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
      gradient_color = [ (c "base0D") (c "base0E") ];
      directory_icon_color = c "base0C";

      # File panel
      file_panel_fg             = c "base05";
      file_panel_bg             = c "base00";
      file_panel_border         = c "base03";
      file_panel_border_active  = c "base0D";
      file_panel_top_directory_icon = c "base0C";
      file_panel_top_path       = c "base0D";
      file_panel_item_selected_fg = c "base0A";
      file_panel_item_selected_bg = c "base02";

      # Footer
      footer_fg            = c "base05";
      footer_bg            = c "base00";
      footer_border        = c "base03";
      footer_border_active = c "base0D";

      # Sidebar
      sidebar_fg              = c "base05";
      sidebar_bg              = c "base00";
      sidebar_title           = c "base08";
      sidebar_border          = c "base00";
      sidebar_border_active   = c "base0D";
      sidebar_item_selected_fg = c "base09";
      sidebar_item_selected_bg = c "base02";
      sidebar_divider         = c "base03";

      # Modals
      modal_fg           = c "base05";
      modal_bg           = c "base00";
      modal_border_active = c "base03";
      modal_cancel_fg    = c "base05";
      modal_cancel_bg    = c "base03";
      modal_confirm_fg   = c "base00";
      modal_confirm_bg   = c "base0B";

      # Help menu
      help_menu_hotkey = c "base0C";
      help_menu_title  = c "base0D";

      # Special
      cursor  = c "base0D";
      correct = c "base0B";
      error   = c "base08";
      hint    = c "base0D";
      cancel  = c "base04";
    };
  };
}
