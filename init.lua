-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("config.lazy")
local opt = vim.opt
-- Global variables
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Vim options
vim.opt.number = true
vim.opt.relativenumber = true
opt.laststatus = 2
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.updatetime = 300 -- faster completion (4000ms default)
opt.cmdheight = 1
opt.spell = false
opt.spelllang:append("en")
opt.wrap = false
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

vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.g.autoformat = true

-- Basic keymaps
-- Unique keymaps not covered by which-key.lua
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- File explorer (unique)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move line down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move line up in visual mode
vim.keymap.set("n", "J", "mzJ`z") -- Join lines and keep cursor position
vim.keymap.set("x", "<leader>p", [["_dP]]) -- Paste without losing register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- Yank line to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]]) -- Delete to black hole register (changed from <leader>d)
vim.keymap.set("n", "Q", "<nop>") -- Disable Ex mode
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") -- Tmux sessionizer
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format) -- LSP format (moved to <leader>lf)
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz") -- Quickfix next (changed from <C-k>)
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz") -- Quickfix prev (changed from <C-j>)
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz") -- Location list next (changed from <leader>k)
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz") -- Location list prev (changed from <leader>j)
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Search and replace (changed from <leader>s)
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true }) -- Make executable (changed from <leader>x)

-- Auto commands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.g.root_spec = { "cwd" }
vim.g.python3_host_prog = "/usr/bin/python3"
