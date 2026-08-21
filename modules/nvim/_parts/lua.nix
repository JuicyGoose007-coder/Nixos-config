{ config, lib, ... }:
{
  programs.nixvim = {
    # withHashtag has ~300 attrs including outPath; take only the 16 base slots.
    globals.stylix_colors = lib.getAttrs (
      map (n: "base0${n}") [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ]
    ) config.lib.stylix.colors.withHashtag;


    # ── Autocommands ─────────────────────────────────────────────────────────
    autoCmd = [
      {
        event = "TextYankPost";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
      {
        event = [
          "FocusGained"
          "BufEnter"
        ];
        command = "checktime";
      }
      {
        event = "FileType";
        callback.__raw = ''
          function(args)
            if pcall(vim.treesitter.start, args.buf) then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
        '';
      }
      {
        # In mini.files, `l` enters a directory or opens a file and closes.
        event = "User";
        pattern = "MiniFilesBufferCreate";
        callback.__raw = ''
          function(args)
            vim.keymap.set("n", "l", function()
              require("mini.files").go_in({ close_on_file = true })
            end, { buffer = args.data.buf_id })
          end
        '';
      }
    ];

    # ── Extra Lua ─────────────────────────────────────────────────────────────
    extraConfigLua = builtins.readFile ../../../dots/nvim/init.lua;
  };
}
