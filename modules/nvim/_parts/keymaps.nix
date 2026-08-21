{ ... }:
{
  programs.nixvim = {

    # ── Keymaps ──────────────────────────────────────────────────────────────
    keymaps = [
      # Save / quit
      {
        key = "<leader>qq";
        action = "<cmd>q<cr>";
        mode = "n";
        options.desc = "Quit";
      }
      {
        key = "<leader>ww";
        action = "<cmd>w<cr>";
        mode = "n";
        options.desc = "Save";
      }
      {
        key = "<leader>wq";
        action = "<cmd>wq<cr>";
        mode = "n";
        options.desc = "Save and quit";
      }
      {
        key = "<leader>so";
        action = "<cmd>so %<cr>";
        mode = "n";
        options.desc = "Source file";
      }

      # File explorer (mini.files — toggle at current file's dir, else cwd)
      {
        key = "<leader>e";
        mode = "n";
        options.desc = "File explorer";
        action.__raw = ''
          function()
            local mf = require("mini.files")
            if not mf.close() then
              local path = vim.api.nvim_buf_get_name(0)
              mf.open(path ~= "" and path or vim.fn.getcwd())
            end
          end
        '';
      }

      # Lazygit (floating terminal)
      {
        key = "<leader>gg";
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
      {
        key = "<leader>ff";
        action = "<cmd>FzfLua files<cr>";
        mode = "n";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<cr>";
        mode = "n";
        options.desc = "Live grep";
      }
      {
        key = "<leader>/";
        action = "<cmd>FzfLua blines<cr>";
        mode = "n";
        options.desc = "Search current file";
      }
      {
        key = "<leader>fb";
        action = "<cmd>FzfLua buffers<cr>";
        mode = "n";
        options.desc = "Find buffers";
      }
      {
        key = "<leader>fc";
        action = "<cmd>FzfLua commands<cr>";
        mode = "n";
        options.desc = "Commands";
      }
      {
        key = "<leader>fk";
        action = "<cmd>FzfLua keymaps<cr>";
        mode = "n";
        options.desc = "Keymaps";
      }
      {
        key = "<leader>*";
        action = "<cmd>FzfLua grep_cword<cr>";
        mode = "n";
        options.desc = "Grep word under cursor";
      }
      {
        key = "<leader>gv";
        action = "<cmd>FzfLua grep_visual<cr>";
        mode = "x";
        options.desc = "Grep visual selection";
      }

      # Grep in current file
      {
        key = "<leader>s*";
        action = "<cmd>grep! <cword> %<cr>";
        mode = "n";
        options.desc = "Grep word in file";
      }

      # Quickfix
      {
        key = "<leader>qo";
        action = "<cmd>copen<cr>";
        mode = "n";
        options.desc = "Open quickfix";
      }
      {
        key = "<leader>qc";
        action = "<cmd>cclose<cr>";
        mode = "n";
        options.desc = "Close quickfix";
      }
      {
        key = "]q";
        action = "<cmd>cnext<cr>";
        mode = "n";
        options.desc = "Next quickfix";
      }
      {
        key = "[q";
        action = "<cmd>cprev<cr>";
        mode = "n";
        options.desc = "Prev quickfix";
      }

      # Harpoon
      {
        key = "<leader>ha";
        mode = "n";
        options.desc = "Harpoon add file";
        action.__raw = "function() require('harpoon'):list():add() end";
      }
      {
        key = "<leader>hh";
        mode = "n";
        options.desc = "Harpoon menu";
        action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end";
      }
      {
        key = "<leader>1";
        mode = "n";
        options.desc = "Harpoon file 1";
        action.__raw = "function() require('harpoon'):list():select(1) end";
      }
      {
        key = "<leader>2";
        mode = "n";
        options.desc = "Harpoon file 2";
        action.__raw = "function() require('harpoon'):list():select(2) end";
      }
      {
        key = "<leader>3";
        mode = "n";
        options.desc = "Harpoon file 3";
        action.__raw = "function() require('harpoon'):list():select(3) end";
      }
      {
        key = "<leader>4";
        mode = "n";
        options.desc = "Harpoon file 4";
        action.__raw = "function() require('harpoon'):list():select(4) end";
      }

      # LSP
      {
        key = "gd";
        action.__raw = "vim.lsp.buf.definition";
        mode = "n";
        options.desc = "Go to definition";
      }
      {
        key = "gR";
        action.__raw = "vim.lsp.buf.references";
        mode = "n";
        options.desc = "References";
      }
      {
        key = "K";
        action.__raw = "vim.lsp.buf.hover";
        mode = "n";
        options.desc = "Hover docs";
      }
      {
        key = "<leader>ca";
        action.__raw = "vim.lsp.buf.code_action";
        mode = "n";
        options.desc = "Code action";
      }
      {
        key = "<leader>cr";
        action.__raw = "vim.lsp.buf.rename";
        mode = "n";
        options.desc = "Rename";
      }

      # Format
      {
        key = "<leader>cf";
        mode = "n";
        options.desc = "Format file";
        action.__raw = "function() require('conform').format({ async = true, lsp_fallback = true }) end";
      }

      # Undotree
      {
        key = "<leader>u";
        action = "<cmd>lua require('undotree').toggle()<cr>";
        mode = "n";
        options.desc = "Undotree";
      }

      # Trouble (diagnostics / quickfix / loclist list)
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        mode = "n";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        mode = "n";
        options.desc = "Buffer diagnostics (Trouble)";
      }
      {
        key = "<leader>xq";
        action = "<cmd>Trouble qflist toggle<cr>";
        mode = "n";
        options.desc = "Quickfix (Trouble)";
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble loclist toggle<cr>";
        mode = "n";
        options.desc = "Location list (Trouble)";
      }

      # todo-comments (fits the fzf-lua <leader>s* / <leader>f* family)
      {
        key = "<leader>st";
        action = "<cmd>TodoFzfLua<cr>";
        mode = "n";
        options.desc = "Search TODOs";
      }
      {
        key = "]t";
        mode = "n";
        options.desc = "Next TODO comment";
        action.__raw = "function() require('todo-comments').jump_next() end";
      }
      {
        key = "[t";
        mode = "n";
        options.desc = "Prev TODO comment";
        action.__raw = "function() require('todo-comments').jump_prev() end";
      }

      # mini.sessions (per-cwd session save/restore)
      {
        key = "<leader>Ss";
        mode = "n";
        options.desc = "Session write";
        action.__raw = "function() require('mini.sessions').write() end";
      }
      {
        key = "<leader>Sl";
        mode = "n";
        options.desc = "Session load/select";
        action.__raw = "function() require('mini.sessions').select() end";
      }

      # mini.diff
      {
        key = "<leader>gd";
        mode = "n";
        options.desc = "Toggle mini.diff overlay";
        action.__raw = "function() require('mini.diff').toggle_overlay(0) end";
      }

      # ── DAP (debugging) ──────────────────────────────────────────────────────
      {
        key = "<leader>db";
        mode = "n";
        options.desc = "Toggle breakpoint";
        action.__raw = "function() require('dap').toggle_breakpoint() end";
      }
      {
        key = "<leader>dc";
        mode = "n";
        options.desc = "Continue / start";
        action.__raw = "function() require('dap').continue() end";
      }
      {
        key = "<leader>di";
        mode = "n";
        options.desc = "Step into";
        action.__raw = "function() require('dap').step_into() end";
      }
      {
        key = "<leader>do";
        mode = "n";
        options.desc = "Step over";
        action.__raw = "function() require('dap').step_over() end";
      }
      {
        key = "<leader>du";
        mode = "n";
        options.desc = "Toggle DAP UI";
        action.__raw = "function() require('dapui').toggle() end";
      }

      # Tmux navigation
      {
        key = "<C-h>";
        action = "<cmd>TmuxNavigateLeft<cr>";
        mode = [
          "n"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        key = "<C-j>";
        action = "<cmd>TmuxNavigateDown<cr>";
        mode = [
          "n"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        key = "<C-k>";
        action = "<cmd>TmuxNavigateUp<cr>";
        mode = [
          "n"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        key = "<C-l>";
        action = "<cmd>TmuxNavigateRight<cr>";
        mode = [
          "n"
          "v"
          "i"
        ];
        options.silent = true;
      }

      # Flash jump (trialling against mini.jump2d)
      {
        key = "<leader>j";
        mode = [
          "n"
          "x"
          "o"
        ];
        options.desc = "Flash jump";
        action.__raw = "function() require('flash').jump() end";
      }

      # Visual-line navigation
      {
        key = "j";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "k";
        mode = [
          "n"
          "x"
        ];
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }

      # Search centred
      {
        key = "n";
        action = "nzzzv";
        mode = "n";
        options.silent = true;
      }
      {
        key = "N";
        action = "Nzzzv";
        mode = "n";
        options.silent = true;
      }

      # Clear search highlight
      {
        key = "<Esc>";
        action = "<cmd>nohlsearch<cr>";
        mode = "n";
      }

      # Buffer switching
      {
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        mode = "n";
        options.desc = "Prev buffer";
      }
      {
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        mode = "n";
        options.desc = "Next buffer";
      }

      # Move lines
      {
        key = "<A-j>";
        action = "<cmd>execute 'move .+' . v:count1<cr>==";
        mode = "n";
        options.desc = "Move line down";
      }
      {
        key = "<A-k>";
        action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
        mode = "n";
        options.desc = "Move line up";
      }
      {
        key = "<A-j>";
        action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
        mode = "v";
        options.desc = "Move selection down";
      }
      {
        key = "<A-k>";
        action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
        mode = "v";
        options.desc = "Move selection up";
      }

      # Indent keeps selection
      {
        key = "<";
        action = "<gv";
        mode = "x";
      }
      {
        key = ">";
        action = ">gv";
        mode = "x";
      }

      # Centred scroll
      {
        key = "<C-d>";
        action = "<C-d>zz";
        mode = "n";
        options.desc = "Scroll down (centred)";
      }
      {
        key = "<C-u>";
        action = "<C-u>zz";
        mode = "n";
        options.desc = "Scroll up (centred)";
      }

      # Join lines keep cursor
      {
        key = "J";
        action = "mzJ`z";
        mode = "n";
        options.desc = "Join lines (keep cursor)";
      }

      # Clipboard
      {
        key = "<leader>y";
        action = ''"+y'';
        mode = [
          "n"
          "v"
        ];
        options.desc = "Yank to clipboard";
      }
      {
        key = "<leader>Y";
        action = ''"+Y'';
        mode = "n";
        options.desc = "Yank line to clipboard";
      }
      {
        key = "<leader>p";
        action = ''"+p'';
        mode = [
          "n"
          "v"
        ];
        options.desc = "Paste from clipboard";
      }

      # Delete to void
      {
        key = "<leader>D";
        action = ''"_d'';
        mode = [
          "n"
          "v"
        ];
        options.desc = "Delete to void";
      }

      # Visual paste without yanking replaced text
      {
        key = "p";
        action = ''"_dP'';
        mode = "v";
        options.desc = "Paste without yanking";
      }

      # Replace word under cursor
      {
        key = "<leader>rw";
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
  };
}
