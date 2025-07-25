-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.loader.enable()
vim.g.lazyvim_picker = "auto"
vim.g.ai_cmp = true
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_blink_main = true
vim.g.autoformat = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.o.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "CursorLine", { fg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff" })
local opt = vim.opt
opt.winblend = 0
opt.pumblend = 0
opt.termguicolors = true
vim.g.lazyvim_eslint_auto_format = true
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- views can only be fully collapsed with the global statusline
opt.laststatus = 2
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.updatetime = 300 -- faster completion (4000ms default)
opt.cmdheight = 1
opt.spell = true
opt.spelllang:append("en")
opt.wrap = true
opt.completeopt = "menuone,noselect"
opt.foldenable = false -- Disable folding completely

-- Enable EditorConfig integration
vim.g.editorconfig = true

-- Root dir detection
vim.g.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.swapfile = false

--Editor
opt.inccommand = "split"
opt.ignorecase = true
opt.syntax = "on"

-- Smoothscroll
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

vim.g.root_spec = { "cwd" }
vim.g.python3_host_prog = "/usr/bin/python3"
