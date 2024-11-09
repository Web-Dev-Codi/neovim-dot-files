-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

local opt = vim.opt
opt.winblend = 0
opt.pumblend = 0
opt.termguicolors = true

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
-- views can only be fully collapsed with the global statusline
opt.laststatus = 3
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.updatetime = 100 -- faster completion (4000ms default)

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

vim.g.root_spec = { "cwd" }
vim.g.python3_host_prog = "/usr/bin/python3"
