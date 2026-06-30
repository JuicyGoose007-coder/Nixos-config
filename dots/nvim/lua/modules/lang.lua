-- Treesitter
require("nvim-treesitter.config").setup({
	ensure_installed = {
		"python",
		"lua",
		"rust",
		"html",
		"css",
		"toml",
		"json",
		"yaml",
		"vim",
		"vimdoc",
		"markdown",
		"kde",
	},
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- LSP
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})

local lsp_servers = { "pyright", "lua_ls", "rust_analyzer", "html", "cssls", "taplo", "yamlls", "jsonls" }
for _, server in ipairs(lsp_servers) do
	vim.lsp.config(server, {})
end
vim.lsp.enable(lsp_servers)

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})

-- Formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" },
		rust = { "rustfmt" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		toml = { "taplo" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
