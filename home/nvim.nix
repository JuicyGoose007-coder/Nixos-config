{ pkgs, config, ... }:

{
  programs.nixvim = {
    enable           = true;
    nixpkgs.source   = pkgs.path;

    globals = {
      mapleader      = " ";
      maplocalleader = " ";
    };

    opts = {
      number         = true;
      relativenumber = true;
      tabstop        = 2;
      shiftwidth     = 2;
      expandtab      = true;
      smartindent    = true;
      wrap           = true;
      linebreak      = true;
      breakindent    = true;
      termguicolors  = true;
      scrolloff      = 8;
      signcolumn     = "yes";
      autoread       = true;
      mouse          = "a";
      undofile       = true;
      clipboard      = "unnamedplus";
      ignorecase     = true;
      smartcase      = true;
      cursorline     = true;
      cmdheight      = 1;
    };

    # ── Colorscheme ──────────────────────────────────────────────────────────
    colorschemes.gruvbox = {
      enable   = true;
      settings = {
        contrast_dark  = "hard";
        italic.strings = false;
      };
    };

    # ── Plugins ──────────────────────────────────────────────────────────────
    plugins = {
      web-devicons.enable      = true;
      friendly-snippets.enable = true;
      which-key.enable         = true;
      harpoon.enable           = true;
      fzf-lua.enable           = true;

      mini = {
        enable  = true;
        modules = {
          ai        = {};
          operators = {};
          pairs     = {};
          surround  = {};
        };
      };

      treesitter = {
        enable = true;
        settings.ensure_installed = [
          "python" "lua" "rust" "html" "css"
          "toml" "json" "yaml" "vim" "vimdoc"
          "markdown" "kde"
        ];
      };

      lsp = {
        enable  = true;
        servers = {
          pyright.enable = true;
          lua_ls.enable  = true;
          taplo.enable   = true;
          yamlls.enable  = true;
          jsonls.enable  = true;
          html.enable    = true;
          cssls.enable   = true;
          rust_analyzer  = {
            enable       = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      conform-nvim = {
        enable   = true;
        settings = {
          formatters_by_ft = {
            lua    = [ "stylua" ];
            python = [ "ruff_organize_imports" "ruff_format" ];
            rust   = [ "rustfmt" ];
            html   = [ "prettier" ];
            css    = [ "prettier" ];
            json   = [ "prettier" ];
            yaml   = [ "prettier" ];
            toml   = [ "taplo" ];
          };
          format_on_save = {
            timeout_ms   = 500;
            lsp_fallback = true;
          };
        };
      };

      blink-cmp = {
        enable   = true;
        settings = {
          keymap = {
            preset    = "enter";
            "<Tab>"   = [ "select_next" "fallback" ];
            "<S-Tab>" = [ "select_prev" "fallback" ];
          };
          completion.ghost_text = {
            enabled                = true;
            show_without_selection = true;
          };
          sources.default = [ "lsp" "path" "snippets" "buffer" ];
        };
      };

      indent-blankline = {
        enable   = true;
        settings = {
          indent.char       = "│";
          scope.enabled     = true;
          exclude.filetypes = [ "ministarter" "help" "dashboard" "alpha" ];
        };
      };

      yazi = {
        enable                       = true;
        settings.open_for_directories = false;
      };
    };

    # ── Extra plugins ────────────────────────────────────────────────────────
    extraPlugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      vim-visual-multi
      (pkgs.vimUtils.buildVimPlugin {
        name = "undotree-jiaoshijie";
        src  = pkgs.fetchFromGitHub {
          owner  = "jiaoshijie";
          repo   = "undotree";
          rev    = "02b69aed427b848c4dca483fc5e9524b6019c296";
          sha256 = "1z33z5kd4p46bmqpxk71p46gi2g32a2dfnyzadd4yi0q7iyqa083";
        };
      })
    ];

    # ── Keymaps ──────────────────────────────────────────────────────────────
    keymaps = [
      # Save / quit
      { key = "<leader>qq"; action = "<cmd>q<cr>";    mode = "n"; options.desc = "Quit"; }
      { key = "<leader>ww"; action = "<cmd>w<cr>";    mode = "n"; options.desc = "Save"; }
      { key = "<leader>wq"; action = "<cmd>wq<cr>";   mode = "n"; options.desc = "Save and quit"; }
      { key = "<leader>so"; action = "<cmd>so %<cr>"; mode = "n"; options.desc = "Source file"; }

      # File explorer
      { key = "<leader>e"; action = "<cmd>Yazi<cr>"; mode = "n"; options.desc = "File explorer"; }

      # Lazygit (floating terminal)
      {
        key  = "<leader>gg";
        mode = "n";
        options.desc = "Lazygit";
        action.__raw = ''
          function()
            local buf    = vim.api.nvim_create_buf(false, true)
            local width  = math.floor(vim.o.columns * 0.9)
            local height = math.floor(vim.o.lines   * 0.9)
            vim.api.nvim_open_win(buf, true, {
              relative = "editor", width = width, height = height,
              row      = math.floor((vim.o.lines   - height) / 2),
              col      = math.floor((vim.o.columns - width)  / 2),
              style    = "minimal", border = "rounded",
            })
            vim.fn.termopen("lazygit", {
              on_exit = function() vim.api.nvim_buf_delete(buf, { force = true }) end,
            })
            vim.cmd.startinsert()
          end
        '';
      }

      # Fuzzy finder
      { key = "<leader>ff"; action = "<cmd>FzfLua files<cr>";       mode = "n"; options.desc = "Find files"; }
      { key = "<leader>fg"; action = "<cmd>FzfLua live_grep<cr>";   mode = "n"; options.desc = "Live grep"; }
      { key = "<leader>/";  action = "<cmd>FzfLua blines<cr>";      mode = "n"; options.desc = "Search current file"; }
      { key = "<leader>fb"; action = "<cmd>FzfLua buffers<cr>";     mode = "n"; options.desc = "Find buffers"; }
      { key = "<leader>fc"; action = "<cmd>FzfLua commands<cr>";    mode = "n"; options.desc = "Commands"; }
      { key = "<leader>fk"; action = "<cmd>FzfLua keymaps<cr>";     mode = "n"; options.desc = "Keymaps"; }
      { key = "<leader>*";  action = "<cmd>FzfLua grep_cword<cr>";  mode = "n"; options.desc = "Grep word under cursor"; }
      { key = "<leader>gv"; action = "<cmd>FzfLua grep_visual<cr>"; mode = "x"; options.desc = "Grep visual selection"; }

      # Grep in current file
      { key = "<leader>s*"; action = "<cmd>grep! <cword> %<cr>"; mode = "n"; options.desc = "Grep word in file"; }

      # Quickfix
      { key = "<leader>qo"; action = "<cmd>copen<cr>";  mode = "n"; options.desc = "Open quickfix"; }
      { key = "<leader>qc"; action = "<cmd>cclose<cr>"; mode = "n"; options.desc = "Close quickfix"; }
      { key = "]q"; action = "<cmd>cnext<cr>"; mode = "n"; options.desc = "Next quickfix"; }
      { key = "[q"; action = "<cmd>cprev<cr>"; mode = "n"; options.desc = "Prev quickfix"; }

      # Harpoon
      { key = "<leader>ha"; mode = "n"; options.desc = "Harpoon add file";
        action.__raw = "function() require('harpoon'):list():add() end"; }
      { key = "<leader>hh"; mode = "n"; options.desc = "Harpoon menu";
        action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end"; }
      { key = "<leader>1"; mode = "n"; options.desc = "Harpoon file 1";
        action.__raw = "function() require('harpoon'):list():select(1) end"; }
      { key = "<leader>2"; mode = "n"; options.desc = "Harpoon file 2";
        action.__raw = "function() require('harpoon'):list():select(2) end"; }
      { key = "<leader>3"; mode = "n"; options.desc = "Harpoon file 3";
        action.__raw = "function() require('harpoon'):list():select(3) end"; }
      { key = "<leader>4"; mode = "n"; options.desc = "Harpoon file 4";
        action.__raw = "function() require('harpoon'):list():select(4) end"; }

      # LSP
      { key = "gd";         action.__raw = "vim.lsp.buf.definition";  mode = "n"; options.desc = "Go to definition"; }
      { key = "gR";         action.__raw = "vim.lsp.buf.references";  mode = "n"; options.desc = "References"; }
      { key = "K";          action.__raw = "vim.lsp.buf.hover";       mode = "n"; options.desc = "Hover docs"; }
      { key = "<leader>ca"; action.__raw = "vim.lsp.buf.code_action"; mode = "n"; options.desc = "Code action"; }
      { key = "<leader>cr"; action.__raw = "vim.lsp.buf.rename";      mode = "n"; options.desc = "Rename"; }

      # Format
      { key = "<leader>cf"; mode = "n"; options.desc = "Format file";
        action.__raw = "function() require('conform').format({ async = true, lsp_fallback = true }) end"; }

      # Undotree
      { key = "<leader>u"; action = "<cmd>lua require('undotree').toggle()<cr>"; mode = "n"; options.desc = "Undotree"; }

      # Tmux navigation
      { key = "<C-h>"; action = "<cmd>TmuxNavigateLeft<cr>";  mode = ["n" "v" "i"]; options.silent = true; }
      { key = "<C-j>"; action = "<cmd>TmuxNavigateDown<cr>";  mode = ["n" "v" "i"]; options.silent = true; }
      { key = "<C-k>"; action = "<cmd>TmuxNavigateUp<cr>";    mode = ["n" "v" "i"]; options.silent = true; }
      { key = "<C-l>"; action = "<cmd>TmuxNavigateRight<cr>"; mode = ["n" "v" "i"]; options.silent = true; }

      # Visual-line navigation
      { key = "j"; mode = ["n" "x"]; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; }; }
      { key = "k"; mode = ["n" "x"]; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; }; }

      # Search centred
      { key = "n"; action = "nzzzv"; mode = "n"; options.silent = true; }
      { key = "N"; action = "Nzzzv"; mode = "n"; options.silent = true; }

      # Clear search highlight
      { key = "<Esc>"; action = "<cmd>nohlsearch<cr>"; mode = "n"; }

      # Buffer switching
      { key = "<S-h>"; action = "<cmd>bprevious<cr>"; mode = "n"; options.desc = "Prev buffer"; }
      { key = "<S-l>"; action = "<cmd>bnext<cr>";     mode = "n"; options.desc = "Next buffer"; }

      # Move lines
      { key = "<A-j>"; action = "<cmd>execute 'move .+' . v:count1<cr>=="; mode = "n"; options.desc = "Move line down"; }
      { key = "<A-k>"; action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>=="; mode = "n"; options.desc = "Move line up"; }
      { key = "<A-j>"; action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv"; mode = "v"; options.desc = "Move selection down"; }
      { key = "<A-k>"; action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv"; mode = "v"; options.desc = "Move selection up"; }

      # Indent keeps selection
      { key = "<"; action = "<gv"; mode = "x"; }
      { key = ">"; action = ">gv"; mode = "x"; }

      # Centred scroll
      { key = "<C-d>"; action = "<C-d>zz"; mode = "n"; options.desc = "Scroll down (centred)"; }
      { key = "<C-u>"; action = "<C-u>zz"; mode = "n"; options.desc = "Scroll up (centred)"; }

      # Join lines keep cursor
      { key = "J"; action = "mzJ`z"; mode = "n"; options.desc = "Join lines (keep cursor)"; }

      # Clipboard
      { key = "<leader>y"; action = ''"+y''; mode = ["n" "v"]; options.desc = "Yank to clipboard"; }
      { key = "<leader>Y"; action = ''"+Y''; mode = "n";       options.desc = "Yank line to clipboard"; }
      { key = "<leader>p"; action = ''"+p''; mode = ["n" "v"]; options.desc = "Paste from clipboard"; }

      # Delete to void
      { key = "<leader>D"; action = ''"_d''; mode = ["n" "v"]; options.desc = "Delete to void"; }

      # Visual paste without yanking replaced text
      { key = "p"; action = ''"_dP''; mode = "v"; options.desc = "Paste without yanking"; }

      # Replace word under cursor
      {
        key  = "<leader>rw";
        mode = "n";
        options.desc = "Replace word under cursor";
        action.__raw = ''
          function()
            local word = vim.fn.expand("<cword>")
            local cmd  = ":%s/\\<" .. word .. "\\>//gc<Left><Left><Left>"
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
          end
        '';
      }
    ];

    # ── Autocommands ─────────────────────────────────────────────────────────
    autoCmd = [
      {
        event    = "TextYankPost";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
      {
        event   = [ "FocusGained" "BufEnter" ];
        command = "checktime";
      }
      {
        event    = "FileType";
        callback.__raw = ''
          function(args)
            if pcall(vim.treesitter.start, args.buf) then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
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
            { name = "config  󰒓",    action = "edit /etc/nixos/home/nvim.nix", section = "Actions" },
            { name = "explorer  󰙅",    action = "Yazi",                     section = "Actions" },
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
