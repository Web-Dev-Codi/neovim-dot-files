vim.g.mapleader = " "
vim.g.mapLocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Lazy Load Plugin
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })

require("lazy").setup "plugins"

require "vim-options"
