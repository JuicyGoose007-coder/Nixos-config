{ pkgs, ... }:
{
  programs.nixvim = {

    # ── Plugins ──────────────────────────────────────────────────────────────
    plugins = {
      web-devicons.enable = true;
      friendly-snippets.enable = true;
      which-key.enable = true;
      harpoon.enable = true;
      fzf-lua.enable = true;
      flash.enable = true;

      mini = {
        enable = true;
        modules = {
          ai = { };
          operators = { };
          sessions = { }; # per-cwd session save/restore (see <leader>S* keymaps)
          pairs = { };
          surround = { };
          files = {
            mappings = {
              go_in_plus = "<CR>";
            };
          };
          diff = { };
          bracketed = { };
          trailspace = { };
          hipatterns = {
            highlighters = {
              fixme = {
                pattern = "%f[%w]()FIXME()%f[%W]";
                group = "MiniHipatternsFixme";
              };
              hack = {
                pattern = "%f[%w]()HACK()%f[%W]";
                group = "MiniHipatternsHack";
              };
              todo = {
                pattern = "%f[%w]()TODO()%f[%W]";
                group = "MiniHipatternsTodo";
              };
              note = {
                pattern = "%f[%w]()NOTE()%f[%W]";
                group = "MiniHipatternsNote";
              };
              hex_color = {
                __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
              };
            };
          };
        };
      };

      treesitter = {
        enable = true;
        settings.ensure_installed = [
          "python"
          "lua"
          "rust"
          "html"
          "css"
          "toml"
          "json"
          "yaml"
          "vim"
          "vimdoc"
          "markdown"
          "markdown_inline"
          "kde"
        ];
      };

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          lua_ls.enable = true;
          taplo.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          cssls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            lua = [ "stylua" ];
            python = [
              "ruff_organize_imports"
              "ruff_format"
            ];
            rust = [ "rustfmt" ];
            html = [ "prettier" ];
            css = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            toml = [ "taplo" ];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
        };
      };

      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          completion.ghost_text = {
            enabled = true;
            show_without_selection = true;
          };
          sources.default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope.enabled = true;
          exclude.filetypes = [
            "ministarter"
            "help"
            "dashboard"
            "alpha"
          ];
        };
      };

      trouble.enable = true; # diagnostics / quickfix / loclist list
      fidget.enable = true; # LSP progress spinner
      todo-comments.enable = true; # search/jump the TODOs mini.hipatterns highlights
      render-markdown.enable = true; # inline markdown rendering

      # ── Debugging (DAP) ──────────────────────────────────────────────────────
      dap = {
        enable = true;
        # Auto-open / auto-close dap-ui around a debug session.
        extensionConfigLua = ''
          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
        '';
      };
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      dap-python.enable = true; # adapterPythonPath defaults to python3 + debugpy

      dap-lldb = {
        enable = true; # Rust/C/C++: ships ready-made Debug / Debug tests / Attach configs
        settings.codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      };
    };

    # ── Extra plugins ────────────────────────────────────────────────────────
    extraPlugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      vim-visual-multi
      (pkgs.vimUtils.buildVimPlugin {
        name = "undotree-jiaoshijie";
        src = pkgs.fetchFromGitHub {
          owner = "jiaoshijie";
          repo = "undotree";
          rev = "02b69aed427b848c4dca483fc5e9524b6019c296";
          sha256 = "1z33z5kd4p46bmqpxk71p46gi2g32a2dfnyzadd4yi0q7iyqa083";
        };
      })
    ];
  };
}
