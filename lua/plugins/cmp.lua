-- DISABLED: nvim-cmp to prevent conflicts with blink.cmp
-- blink.cmp is now the primary completion engine
-- This file only keeps LuaSnip for snippet support

return {
  -- nvim-cmp and all related plugins are completely disabled - using blink.cmp instead
  {
    "hrsh7th/nvim-cmp",
    enabled = false, -- Completely disable to prevent dual completion windows
    -- All completion is now handled by blink.cmp in lua/plugins/blink.lua
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    enabled = false, -- Disable to prevent module 'cmp' not found errors
  },
  {
    "hrsh7th/cmp-buffer",
    enabled = false, -- Disable cmp-buffer
  },
  {
    "hrsh7th/cmp-path",
    enabled = false, -- Disable cmp-path
  },
  {
    "saadparwaiz1/cmp_luasnip",
    enabled = false, -- Disable cmp_luasnip
  },
  -- Keep LuaSnip for snippet support with blink.cmp
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      -- Load VSCode-style snippets for use with blink.cmp
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- Enhanced Lua development support
  {
    "folke/lazydev.nvim",
    ft = "lua",
    lazy = true,
    opts = {
      library = { -- Load luvit types when the `vim.uv` word is found
        {
          path = "luvit-meta/library",
          words = { "vim%.uv" },
        },
      },
    },
  },
  -- LSP progress notifications
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        suppress_on_insert = false, -- Show progress notifications in insert mode
        ignore_done_already = false, -- Don't ignore notifications that are already done
        ignore_empty_message = false, -- Don't ignore empty progress messages
        display = {
          render_limit = 16, -- How many LSP messages to show at once
          done_ttl = 3, -- How long to show completed progress
          done_icon = "✓", -- Icon for completed progress
        },
      },
      notification = {
        window = {
          winblend = 0,
          border = "rounded",
        },
      },
    },
  },
}
