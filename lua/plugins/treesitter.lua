local config = function()
  require("nvim-treesitter.configs").setup {
    build = ":TSUpdate",
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
      filetypes = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    ensure_installed = {
      "rust",
      "markdown",
      "json",
      "rust",
      "javascript",
      "typescript",
      "yaml",
      "html",
      "markdown_inline",
      "css",
      "bash",
      "lua",
      "gitignore",
      "toml",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    ts_context_commentstring = {
      enable = true,
      enable_autocmd = false,
      config = {
        -- Languages that have a single comment style
        typescript = "// %s",
        css = "/* %s */",
        scss = "/* %s */",
        html = "<!-- %s -->",
        svelte = "<!-- %s -->",
        vue = "<!-- %s -->",
        json = "",
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-s>",
        node_incremental = "<C-s>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = config,
  },
  {
    -- Lazy loaded by Comment.nvim pre_hook
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
}
