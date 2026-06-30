-- Which-key
require("which-key").setup()

-- Indent guides
require("ibl").setup({
	indent = { char = "│" },
	scope = { enabled = true },
})

-- File explorer
require("yazi").setup({
	view_options = { show_hidden = true },
})

-- Undotree
require("undotree").setup()

-- Fuzzy finder
require("fzf-lua").setup()
