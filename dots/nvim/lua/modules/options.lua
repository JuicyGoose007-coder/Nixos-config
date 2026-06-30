-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.autoread = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true

if vim.fn.executable("rg") == 1 then
	-- set ripgrep as the grep program and tell it to format output for quickfix
	vim.opt.grepprg = "rg --vimgrep --smart-case"
	vim.opt.grepformat = "%f:%1:%c:%m"
end
