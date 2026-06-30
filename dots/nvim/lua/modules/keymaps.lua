-- Keymaps

-- Local Harpoon
local harpoon = require("harpoon")

-- Save / quit
vim.keymap.set("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>so", "<cmd>so %<cr>", { desc = "Source file" })
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart nvim" })

-- File explorer
vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "File explorer" })

-- Git
vim.keymap.set("n", "<leader>gg", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.fn.termopen("lazygit", {
		on_exit = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})
	vim.cmd.startinsert()
end, { desc = "Lazygit" })

-- Fuzzy finder
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua blines<cr>", { desc = "Search current file" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>*", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep word under cursor" })
vim.keymap.set("x", "<leader>gv", "<cmd>FzfLua grep_visual<cr>", { desc = "Grep visual selection" })

-- Grep in current file via quickfix
vim.keymap.set("n", "<leader>s*", "<cmd>grep! <cword> %<cr>", { desc = "Grep word in current file" })

-- Quickfix navigation
vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })

-- Harpoon
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
for i = 1, 4 do
	vim.keymap.set("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon file " .. i })
end

-- LSP (gR for references — gr reserved for mini.operators replace)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gR", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- Format
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Undotree
vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Undotree" })

-- Tmux navigation
for key, dir in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
	vim.keymap.set({ "n", "v", "i" }, "<C-" .. key .. ">", "<cmd>TmuxNavigate" .. dir .. "<cr>", { silent = true })
end

-- Visual line navigation
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- n/N keep search centered
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Esc clears search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Buffer switching
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Move lines
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set(
	"v",
	"<A-k>",
	":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
	{ desc = "Move selection up" }
)

-- Indenting keeps visual selection
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Join lines keep cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Delete to void register
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete to void" })

-- Visual paste without yanking replaced text
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Replace word under cursor across file
vim.keymap.set("n", "<leader>rw", function()
	local word = vim.fn.expand("<cword>")
	local cmd = ":%s/\\<" .. word .. "\\>//gc<Left><Left><Left>"
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
end, { desc = "Replace word under cursor" })
