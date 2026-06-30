-- Completion
require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	completion = {
		ghost_text = {
			enabled = true,
			show_without_selection = true,
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})
