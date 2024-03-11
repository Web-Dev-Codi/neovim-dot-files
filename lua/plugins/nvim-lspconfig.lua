return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Setup language servers.
    -- local lspconfig = require "lspconfig"
    --  lspconfig.lua_ls.setup {}
    --  lspconfig.tsserver.setup {}

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
  end,
}
