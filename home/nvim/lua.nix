{ config, ... }:
{
  programs.nixvim = {

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
    extraConfigLua = ''
      -- Transparent background
      -- vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

      -- Ripgrep as grep program
      if vim.fn.executable("rg") == 1 then
        vim.opt.grepprg    = "rg --vimgrep --smart-case"
        vim.opt.grepformat = "%f:%l:%c:%m"
      end

      -- Undo dir
      vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text     = true,
        signs            = true,
        underline        = true,
        update_in_insert = false,
      })

      -- Undotree
      require("undotree").setup()

      -- Mini starter (dashboard)
      local starter = require("mini.starter")
      starter.setup({
        autoopen        = true,
        evaluate_single = true,
        header = table.concat({
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
          "                     ネオヴィム",
        }, "\n"),
        items = {
          {
            { name = "find files  󰈞",  action = "FzfLua files",             section = "Actions" },
            { name = "grep  󰍉",        action = "FzfLua live_grep",         section = "Actions" },
            { name = "config  󰒓",    action = "edit /etc/nixos/home/nvim", section = "Actions" },
            { name = "explorer  󰙅",    action = "lua require('mini.files').open()", section = "Actions" },
            { name = "new file  󰈔",    action = "enew",                     section = "Actions" },
            { name = "quit  󰩈",        action = "qall",                     section = "Actions" },
          },
          starter.sections.recent_files(5, false, false),
        },
        footer        = "",
        content_hooks = {
          starter.gen_hook.adding_bullet("▌ ", false),
          starter.gen_hook.aligning("center", "center"),
        },
      })

      -- Mini starter highlight groups (Gruvbox)
      vim.api.nvim_set_hl(0, "MiniStarterHeader",        { fg = "#${config.lib.stylix.colors.base0A}", bold   = true })
      vim.api.nvim_set_hl(0, "MiniStarterSection",       { fg = "#${config.lib.stylix.colors.base0C}", bold   = true })
      vim.api.nvim_set_hl(0, "MiniStarterItem",          { fg = "#${config.lib.stylix.colors.base05}" })
      vim.api.nvim_set_hl(0, "MiniStarterItemBullet",    { fg = "#${config.lib.stylix.colors.base02}" })
      vim.api.nvim_set_hl(0, "MiniStarterItemPrefix",    { fg = "#${config.lib.stylix.colors.base08}", bold   = true })
      vim.api.nvim_set_hl(0, "MiniStarterQuery",         { fg = "#${config.lib.stylix.colors.base0B}" })
      vim.api.nvim_set_hl(0, "MiniStarterInactive",      { fg = "#${config.lib.stylix.colors.base02}" })
      vim.api.nvim_set_hl(0, "MiniStarterFooter",        { fg = "#${config.lib.stylix.colors.base03}", italic = true })
      vim.api.nvim_set_hl(0, "MiniStarterCurrentBullet", { fg = "#${config.lib.stylix.colors.base0A}", bold   = true })

      -- Dynamic ▌ highlight on current item
      vim.api.nvim_create_autocmd("User", {
        pattern  = "MiniStarterOpened",
        callback = function(ev)
          local buf = ev.buf
          local ns  = vim.api.nvim_create_namespace("starter_bullet_hl")
          local function update()
            vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
            local row  = vim.api.nvim_win_get_cursor(0)[1] - 1
            local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
            local col  = line:find("▌", 1, true)
            if col then
              vim.api.nvim_buf_add_highlight(buf, ns, "MiniStarterCurrentBullet", row, col - 1, col + 2)
            end
          end
          vim.api.nvim_create_autocmd("CursorMoved", { buffer = buf, callback = update })
          update()
          vim.opt_local.cursorline = false
          vim.opt_local.guicursor  = "a:ver1-blinkwait0-blinkon0-blinkoff0"
          vim.b.miniindentscope_disable = true
          local ibl_ok, ibl = pcall(require, "ibl")
          if ibl_ok then ibl.setup_buffer(0, { enabled = false }) end
          vim.api.nvim_create_autocmd("BufWinEnter", {
            buffer   = buf,
            once     = true,
            callback = function()
              local ok, _ibl = pcall(require, "ibl")
              if ok then _ibl.setup_buffer(0, { enabled = false }) end
            end,
          })
        end,
      })

      -- Custom mini.statusline
      local statusline = require("mini.statusline")
      local mode_map = {
        ["n"]   = { "N",   "MiniStatuslineModeNormal"  },
        ["v"]   = { "V",   "MiniStatuslineModeVisual"  },
        ["V"]   = { "V-L", "MiniStatuslineModeVisual"  },
        ["\22"] = { "V-B", "MiniStatuslineModeVisual"  },
        ["s"]   = { "S",   "MiniStatuslineModeVisual"  },
        ["S"]   = { "S-L", "MiniStatuslineModeVisual"  },
        ["i"]   = { "I",   "MiniStatuslineModeInsert"  },
        ["R"]   = { "R",   "MiniStatuslineModeReplace" },
        ["c"]   = { "C",   "MiniStatuslineModeCommand" },
        ["r"]   = { "P",   "MiniStatuslineModeOther"   },
        ["!"]   = { "Sh",  "MiniStatuslineModeOther"   },
        ["t"]   = { "T",   "MiniStatuslineModeOther"   },
      }
      statusline.setup({
        content = {
          active = function()
            local m = mode_map[vim.fn.mode()] or { "?", "MiniStatuslineModeOther" }
            local mode, mode_hl = m[1], m[2]
            local git         = statusline.section_git({ trunc_width = 40 })
            local diff        = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp         = statusline.section_lsp({ trunc_width = 75 })
            local filename    = statusline.section_filename({ trunc_width = 140 })
            local fileinfo    = statusline.section_fileinfo({ trunc_width = 120 })
            local location    = statusline.section_location({ trunc_width = 75 })
            local search      = statusline.section_searchcount({ trunc_width = 75 })
            return statusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
        },
      })

      -- Experimental floating cmdline
      pcall(function()
        require("vim._core.ui2").enable({
          enable = true,
          msg = {
            targets = {
              [""]         = "msg",   empty        = "cmd",
              bufwrite     = "msg",   confirm      = "cmd",
              emsg         = "pager", echo         = "msg",
              echomsg      = "msg",   echoerr      = "pager",
              completion   = "cmd",   list_cmd     = "pager",
              lua_error    = "pager", lua_print    = "msg",
              progress     = "pager", rpc_error    = "pager",
              quickfix     = "msg",   search_cmd   = "cmd",
              search_count = "cmd",   shell_cmd    = "pager",
              shell_err    = "pager", shell_out    = "pager",
              shell_ret    = "msg",   undo         = "msg",
              verbose      = "pager", wildlist     = "cmd",
              wmsg         = "msg",   typed_cmd    = "cmd",
            },
            cmd    = { height = 0.5 },
            dialog = { height = 0.5 },
            msg    = { height = 0.3, timeout = 5000 },
            pager  = { height = 0.5 },
          },
        })
        local ui2 = require("vim._core.ui2")
        local msgs = require("vim._core.ui2.messages")
        local orig_set_pos = msgs.set_pos
        msgs.set_pos = function(tgt)
          orig_set_pos(tgt)
          if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
            pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
              relative = "editor",
              anchor   = "NE",
              row      = 1,
              col      = vim.o.columns - 1,
              border   = "rounded",
            })
          end
        end
      end)
    '';
  };
}
