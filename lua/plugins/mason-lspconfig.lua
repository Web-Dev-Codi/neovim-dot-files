local opts = {
  ensure_installed = {
    "css-lsp",
    "eslint-lsp",
    "tsserver",
    "tailwindcss",
    "lua_ls",
    "emmet_ls",
    "jsonls",
    "clangd",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "prettierd",
    "prettier",
    "rust-analyzer",
    "stylua",
    "tailwindcss-language-server",
    "typescript-language-server",
  },

  automatic_installation = true,
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
