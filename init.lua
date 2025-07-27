require("config.lazy")

-- Vim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- Global variables
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic keymaps
-- Unique keymaps not covered by which-key.lua
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)  -- File explorer (unique)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- Move line down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- Move line up in visual mode
vim.keymap.set("n", "J", "mzJ`z")  -- Join lines and keep cursor position
vim.keymap.set("x", "<leader>p", [["_dP]])  -- Paste without losing register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])  -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])  -- Yank line to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]])  -- Delete to black hole register (changed from <leader>d)
vim.keymap.set("n", "Q", "<nop>")  -- Disable Ex mode
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")  -- Tmux sessionizer
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)  -- LSP format (moved to <leader>lf)
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")  -- Quickfix next (changed from <C-k>)
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")  -- Quickfix prev (changed from <C-j>)
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")  -- Location list next (changed from <leader>k)
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")  -- Location list prev (changed from <leader>j)
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])  -- Search and replace (changed from <leader>s)
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true })  -- Make executable (changed from <leader>x)

-- Auto commands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
