return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    --Treesitter config
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "rust",
        "typescript",
        "css",
        "lua",
        "javascript",
        "html",
        "astro",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "json",
        "toml",
        "tsx",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    })
  end,
}
