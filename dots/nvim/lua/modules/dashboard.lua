-- Dashboard
-- Tokyo Night Moon palette
local c = {
	blue = "#82aaff",
	fg = "#c8d3f5",
	fg_muted = "#828bb8",
	red = "#ff757f",
	green = "#c3e88d",
	cyan = "#86e1fc",
	purple = "#c099ff",
	yellow = "#ffc777",
	orange = "#ff966c",
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dashboard",
	once = true,
	callback = function()
		vim.b.miniindentscope_disable = true
		require("ibl").setup_buffer(0, { enabled = false })

		-- Section highlights
		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = c.blue, bold = true })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = c.fg_muted, italic = true })
		vim.api.nvim_set_hl(0, "DashboardMruTitle", { fg = c.cyan, bold = true })
		vim.api.nvim_set_hl(0, "DashboardFiles", { fg = c.fg })

		-- Per-shortcut colors
		vim.api.nvim_set_hl(0, "DSFiles", { fg = c.blue })
		vim.api.nvim_set_hl(0, "DSGrep", { fg = c.purple })
		vim.api.nvim_set_hl(0, "DSConfig", { fg = c.yellow })
		vim.api.nvim_set_hl(0, "DSExplorer", { fg = c.green })
		vim.api.nvim_set_hl(0, "DSNewFile", { fg = c.cyan })
		vim.api.nvim_set_hl(0, "DSQuit", { fg = c.red })

		-- Deferred so our bindings win over dashboard's MRU number assignments
		local buf = vim.api.nvim_get_current_buf()
		vim.schedule(function()
			local o = { buffer = buf, nowait = true, silent = true }
			vim.keymap.set("n", "f", "<cmd>FzfLua files<cr>", o)
			vim.keymap.set("n", "g", "<cmd>FzfLua live_grep<cr>", o)
			vim.keymap.set("n", "s", "<cmd>edit /etc/nixos/dots/nvim/init.lua<cr>", o)
			vim.keymap.set("n", "e", "<cmd>Yazi<cr>", o)
			vim.keymap.set("n", "n", function()
				vim.ui.input({ prompt = "New file: " }, function(input)
					if input and input ~= "" then
						vim.cmd("edit " .. vim.fn.fnameescape(input))
					end
				end)
			end, o)
			vim.keymap.set("n", "q", "<cmd>qa<cr>", o)
		end)
	end,
})

require("dashboard").setup({
	theme = "hyper",
	shortcut_type = "number",
	config = {
		header = {
			"",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"",
			"                     ネオヴィム                     ",
			"",
		},
		shortcut = {
			{ desc = " 󰈞 Files  f", group = "DSFiles", action = "FzfLua files" },
			{ desc = " 󰍉 Grep  g", group = "DSGrep", action = "FzfLua live_grep" },
			{ desc = " 󰒓 Config  s", group = "DSConfig", action = "edit /etc/nixos/dots/nvim/init.lua" },
			{ desc = " 󰙅 Explorer  e", group = "DSExplorer", action = "Yazi" },
			{ desc = " 󰈔 New File  n", group = "DSNewFile", action = "enew" },
			{ desc = " 󰩈 Quit  q", group = "DSQuit", action = "qa" },
		},

		mru = { limit = 5 },
		project = { enable = false },
		-- footer = { "", "  neovim  —  stay sharp" },
	},
})
