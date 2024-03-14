return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Setup language servers.
    local lspconfig = require "lspconfig"
    lspconfig.lua_ls.setup {}
    lspconfig.tsserver.setup {}
    lspconfig.jsonls.setup {}
    -- lspconfig.emmet_ls.setup {}
    lspconfig.tailwindcss.setup {}
    -- lspconfig.cssls.setup {}
    lspconfig.rust_analyzer.setup {
      -- Server-specific settings. See `:help lspconfig-setup`
      settings = {
        ["rust-analyzer"] = {},
      },
    }

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
  end,
}
