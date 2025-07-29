return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "LspAttach", "BufReadPre", "BufNewFile" },
    config = function()
      -- Configure diagnostic signs and display globally
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Ensure sign column is always visible
      vim.opt.signcolumn = "yes"
    end,
  },
}
