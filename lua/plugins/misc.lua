return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
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
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
          border = "rounded",
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {},
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  { -- https://github.com/smjonas/inc-rename.nvim
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 1000,
      render = "compact",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.25)
      end,
      on_open = function(win)
        return {
          "nvim-telescope/telescope.nvim",
          tag = "0.1.8",
          dependencies = { "nvim-lua/plenary.nvim" },
        },
          vim.api.nvim_win_set_config(win, {
            zindex = 100,
          })
      end,
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      context = 0,
      expand = { "function", "method", "table", "if_statement", "function_declaration", "method_declaration", "pair" },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css", "html", "astro", "lua" },
        user_default_options = {
          names = false,
          rgb_fn = true,
          hsl_fn = true,
          tailwind = "both",
        },
        buftypes = {},
      })
    end,
  },
  { -- https://github.com/b0o/incline.nvim
    "b0o/incline.nvim",
    config = function()
      require("incline").setup()
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
  { -- https://github.com/lukas-reineke/virt-column.nvim
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = { "|" },
      virtcolumn = "80",
      highlight = { "NonText" },
    },
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    require("nvim-ts-autotag").setup({
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
        hint_enable = true,
      },
      -- Also override individual filetype configs, these take priority.
      -- Empty by default, useful if one of the "opts" global settings
      -- doesn't work well in a specific filetype
      per_filetype = {
        ["html"] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
          hint_enable = true,
        },
        ["jsx"] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
          hint_enable = true,
        },
        ["tsx"] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
          hint_enable = true,
        },
      },
    }),
  },
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
      require("tiny-devicons-auto-colors").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "hadolint",
        "prettierd",
        "shfmt",
        "stylua",
        "selene",
        "shellcheck",
        "delve",
        "sql-formatter",
        "biome",
        "codelldb",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
  { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
  {
    "tjdevries/present.nvim",
  },
}
