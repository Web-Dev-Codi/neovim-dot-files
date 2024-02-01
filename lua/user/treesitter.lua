local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup ({
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python", "javascript" },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
  })
end

return M
