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
  { -- https://github.com/folke/zen-mode.nvim
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 120,
      },
      plugins = {
        options = {
          laststatus = 0,
        },
        twilight = {
          enabled = false,
        },
      },
    },
  },
  { -- https://github.com/mg979/vim-visual-multi
    "mg979/vim-visual-multi",
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
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      debug = false, -- set to true to enable debug logging
      log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
      -- default is  ~/.cache/nvim/lsp_signature.log
      verbose = false, -- show debug line number

      bind = true, -- This is mandatory, otherwise border config won't get registered.
      -- If you want to hook lspsaga or other signature handler, pls set to false
      doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- set to 0 if you DO NOT want any API comments be shown
      -- This setting only take effect in insert mode, it does not affect signature help in normal
      -- mode, 10 by default

      max_height = 12, -- max height of signature floating_window
      max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
      -- the value need >= 40
      wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
      floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      -- will set to true when fully tested, set to false will use whichever side has more space
      -- this setting will be helpful if you do not want the PUM and floating win overlap

      floating_window_off_x = 1, -- adjust float windows x position.
      -- can be either a number or function
      floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
      -- can be either number or function, see examples

      close_timeout = 4000, -- close floating window after ms when laster parameter is entered
      fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
      hint_enable = true, -- virtual hint enable
      hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
      -- or, provide a table with 3 icons
      -- hint_prefix = {
      --     above = "↙ ",  -- when the hint is on the line above the current line
      --     current = "← ",  -- when the hint is on the same line
      --     below = "↖ "  -- when the hint is on the line below the current line
      -- }
      hint_scheme = "String",
      hint_inline = function()
        return false
      end, -- should the hint be inline(nvim 0.10 only)?  default false
      -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
      -- return 'right_align' to display hint right aligned in the current line
      hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
      handler_opts = {
        border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
      },

      always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

      auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
      extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
      zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

      padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

      transparency = nil, -- disabled by default, allow floating win transparent value 1~100
      shadow_blend = 36, -- if you using shadow as border use this set the opacity
      shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
      timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
      toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
      -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
      -- may not popup when typing depends on floating_window setting

      select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
      move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating window
      -- e.g. move_cursor_key = '<M-p>',
      -- once moved to floating window, you can use <M-d>, <M-u> to move cursor up and down
      keymaps = {}, -- relate to move_cursor_key; the keymaps inside floating window with arguments of bufnr
      -- e.g. keymaps = function(bufnr) vim.keymap.set(...) end
      -- it can be function that set keymaps
      -- e.g. keymaps = { { 'j', '<C-o>j' }, } this map j to <C-o>j in floating window
      -- <M-d> and <M-u> are default keymaps to move cursor up and down
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-autopairs").setup({ --[[ map_cr = false, ]]
      })
    end,
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
}
