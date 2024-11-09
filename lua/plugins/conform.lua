return {
  "stevearc/conform.nvim",
  optional = true,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      ["markdown"] = { { "prettierd", "prettier" } },
      ["markdown.mdx"] = { { "prettierd", "prettier" } },
      ["javascript"] = { { "prettierd", "prettier" } },
      ["javascriptreact"] = { { "prettierd", "prettier" } },
      ["typescript"] = { { "prettierd", "prettier" } },
      ["typescriptreact"] = { { "prettierd", "prettier" } },
      ["html"] = { { "prettierd", "prettier" } },
      ["css"] = { { "prettierd", "prettier" } },
    },
  },
}
