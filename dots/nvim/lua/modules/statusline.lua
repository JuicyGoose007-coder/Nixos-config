-- Statusline
local statusline = require("mini.statusline")
local mode_map = {
	["n"] = { "N", "MiniStatuslineModeNormal" },
	["v"] = { "V", "MiniStatuslineModeVisual" },
	["V"] = { "V-L", "MiniStatuslineModeVisual" },
	["\22"] = { "V-B", "MiniStatuslineModeVisual" },
	["s"] = { "S", "MiniStatuslineModeVisual" },
	["S"] = { "S-L", "MiniStatuslineModeVisual" },
	["i"] = { "I", "MiniStatuslineModeInsert" },
	["R"] = { "R", "MiniStatuslineModeReplace" },
	["c"] = { "C", "MiniStatuslineModeCommand" },
	["r"] = { "P", "MiniStatuslineModeOther" },
	["!"] = { "Sh", "MiniStatuslineModeOther" },
	["t"] = { "T", "MiniStatuslineModeOther" },
}
statusline.setup({
	content = {
		active = function()
			local m = mode_map[vim.fn.mode()] or { "?", "MiniStatuslineModeOther" }
			local mode, mode_hl = m[1], m[2]
			local git = statusline.section_git({ trunc_width = 40 })
			local diff = statusline.section_diff({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local lsp = statusline.section_lsp({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })
			local search = statusline.section_searchcount({ trunc_width = 75 })

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})
