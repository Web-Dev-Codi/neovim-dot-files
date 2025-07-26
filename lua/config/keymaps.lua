-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Keymaps for better default experience

local map = vim.keymap.set
-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Lua
vim.keymap.set("n", "<leader>mr", require("micropython_nvim").run)
-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
map("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Save and load session
vim.keymap.set("n", "<leader>ss", ":mksession! .session.vim<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>sl", ":source .session.vim<CR>", { noremap = true, silent = false })

-- CodeCompanion Chat
map({ "n", "v" }, "<Leader>a", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
map({ "n", "v" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
map({ "n", "v" }, "<Leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "Open CodeCompanion Chat" })

-- Code-specific actions (work in visual mode)
map("v", "<Leader>cr", "", opts) -- Handled by prompt library
map("v", "<Leader>ct", "", opts) -- Handled by prompt library
map("v", "<Leader>ce", "", opts) -- Handled by prompt library
map("v", "<Leader>cf", "", opts) -- Handled by prompt library
map("v", "<Leader>co", "", opts) -- Handled by prompt library
map("v", "<Leader>cc", "", opts) -- Handled by prompt library
map("v", "<Leader>cd", "", opts) -- Handled by prompt library

-- Quick inline completions
map("n", "<Leader>ai", function()
  require("codecompanion").prompt("Complete this code", {
    adapter = "code_completion",
    strategy = "inline",
  })
end, { desc = "Inline Code Completion" })

-- LSP Integration commands
map("n", "<Leader>ad", "<cmd>CodeCompanionFixDiagnostics<cr>", { desc = "Fix LSP Diagnostics" })

-- Advanced features
map("n", "<Leader>as", function()
  -- Send current file context to chat
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  local filetype = vim.bo.filetype
  require("codecompanion").chat({
    context = "Current file content:\n```" .. filetype .. "\n" .. content .. "\n```",
  })
end, { desc = "Send File to Chat" })

map("n", "<Leader>al", function()
  -- Send LSP hover info to chat
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
    if result and result.contents then
      local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      require("codecompanion").chat({
        context = "LSP hover information:\n" .. table.concat(hover_content, "\n"),
      })
    end
  end)
end, { desc = "Send LSP Hover to Chat" })

-- Model switching
map("n", "<Leader>am", function()
  local models = {
    "codegemma:7b",
    "codellama:7b",
    "codellama:13b",
    "codellama:34b",
    "deepcoder:14b",
    "deepseek-coder:6.7b",
    "deepseek-r1:32b",
    "fastcode:latest",
    "llama3.1:8b",
    "llama3.2:3b",
    "phind-codellama:34b",
    "qwen2.5-coder:7b",
  }
  vim.ui.select(models, {
    prompt = "Select model:",
  }, function(choice)
    if choice then
      -- Update the default model for current session
      local codecompanion = require("codecompanion")
      local config = codecompanion.config or {}
      if config.adapters and config.adapters.ollama then
        if type(config.adapters.ollama) == "function" then
          -- The adapter is a function, need to get the instance and update it
          local adapter = config.adapters.ollama()
          if adapter and adapter.schema and adapter.schema.model then
            adapter.schema.model.default = choice
          end
        else
          -- Direct adapter config
          if config.adapters.ollama.schema and config.adapters.ollama.schema.model then
            config.adapters.ollama.schema.model.default = choice
          end
        end
      end
      print("Switched to model: " .. choice)
    end
  end)
end, { desc = "Switch Model" })
