return {
  { -- https://github.com/smjonas/inc-rename.nvim
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 500,
      render = "compact",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.25)
      end,
      on_open = function(win)
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
  { -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left = "H",
        right = "L",
        down = "J",
        up = "K",

        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
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
  { -- https://github.com/s1n7ax/nvim-window-picker
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        -- type of hints you want to get
        -- following types are supported
        -- 'statusline-winbar' | 'floating-big-letter'
        -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
        -- 'floating-big-letter' draw big letter on a floating window
        -- used

        -- when you go to window selection mode, status bar will show one of
        -- following letters on them so you can use that letter to select the window
        selection_chars = "FJDKSLA;CMRUEIWOQP",

        -- This section contains picker specific configurations
        picker_config = {
          statusline_winbar_picker = {
            -- You can change the display string in status bar.
            -- It supports '%' printf style. Such as `return char .. ': %f'` to display
            -- buffer file path. See :h 'stl' for details.
            selection_display = function(char, windowid)
              return "%=" .. char .. "%="
            end,

            -- whether you want to use winbar instead of the statusline
            -- "always" means to always use winbar,
            -- "never" means to never use winbar
            -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
            use_winbar = "never", -- "always" | "never" | "smart"
          },

          floating_big_letter = {
            -- window picker plugin provides bunch of big letter fonts
            -- fonts will be lazy loaded as they are being requested
            -- additionally, user can pass in a table of fonts in to font
            -- property to use instead

            font = "ansi-shadow", -- ansi-shadow |
          },
        },

        -- whether to show 'Pick window:' prompt
        show_prompt = true,

        -- prompt message to show to get the user input
        prompt_message = "Pick window: ",

        -- if you want to manually filter out the windows, pass in a function that
        -- takes two parameters. You should return window ids that should be
        -- included in the selection
        -- EX:-
        -- function(window_ids, filters)
        --    -- folder the window_ids
        --    -- return only the ones you want to include
        --    return {1000, 1001}
        -- end
        filter_func = nil,

        -- following filters are only applied when you are using the default filter
        -- defined by this plugin. If you pass in a function to "filter_func"
        -- property, you are on your own
        filter_rules = {
          -- when there is only one window available to pick from, use that window
          -- without prompting the user to select
          autoselect_one = true,

          -- whether you want to include the window you are currently on to window
          -- selection or not
          include_current_win = false,

          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "NvimTree", "neo-tree", "notify" },

            -- if the file type is one of following, the window will be ignored
            buftype = { "terminal" },
          },

          -- filter using window options
          wo = {},

          -- if the file path contains one of following names, the window
          -- will be ignored
          file_path_contains = {},

          -- if the file name contains one of following names, the window will be
          -- ignored
          file_name_contains = {},
        },

        -- You can pass in the highlight name or a table of content to set as
        -- highlight
        highlights = {
          statusline = {
            focused = {
              fg = "#ededed",
              bg = "#e35e4f",
              bold = true,
            },
            unfocused = {
              fg = "#ededed",
              bg = "#44cc41",
              bold = true,
            },
          },
          winbar = {
            focused = {
              fg = "#ededed",
              bg = "#e35e4f",
              bold = true,
            },
            unfocused = {
              fg = "#ededed",
              bg = "#44cc41",
              bold = true,
            },
          },
        },
      })
    end,
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
}
