-- Colorscheme
vim.cmd.colorscheme("gruvbox")

-- Statusline (Gruvbox)
local bg = "#282828"
local bg_mid = "#3c3836"
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = bg, bg = "#83a598", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = bg, bg = "#b8bb26", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = bg, bg = "#fe8019", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = bg, bg = "#fb4934", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = bg, bg = "#fabd2f", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = bg, bg = "#8ec07c", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = "#a89984", bg = bg_mid })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#ebdbb2", bg = bg_mid })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = "#a89984", bg = bg })
vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = "#a89984", bg = bg })

-- Experimental UI2: floating cmdline and messages
vim.o.cmdheight = 1
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})

