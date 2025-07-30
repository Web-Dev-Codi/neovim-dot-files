return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Set light or dark variant
        variant = "auto", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

        -- Enable transparent background
        transparent = true, -- accepts a boolean value. true will set the background to transparent, false will set it to the default background color

        -- Reduce the overall saturation of colours for a more muted look
        saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

        -- Enable italics comments
        italic_comments = true, -- accepts a boolean value. true will set comments to italic, false will disable italics for comments

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = false,

        -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
        borderless_pickers = false,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
        cache = true, -- accepts a boolean value. true will enable caching of highlights, false will disable caching

        -- Override highlight groups with your own colour values
        highlights = {
          -- Highlight groups to override, adding new groups is also possible
          -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

          -- Example:
          Comment = { fg = "#696969", bg = "NONE", italic = true },

          -- More examples can be found in `lua/cyberdream/extensions/*.lua`
        },

        -- Override a highlight group entirely using the built-in colour palette
        overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
          -- Example:
          return {
            Comment = { fg = colors.green, bg = "NONE", italic = true },
            ["@property"] = { fg = colors.magenta, bold = true },
          }
        end,

        -- Override colors
        colors = {
          -- For a list of colors see `lua/cyberdream/colours.lua`

          -- Override colors for both light and dark variants
          bg = "#000000",
          green = "#00ff00",

          -- If you want to override colors for light or dark variants only, use the following format:
          dark = {
            magenta = "#ff00ff",
            fg = "#eeeeee",
          },
          light = {
            red = "#ff5c57",
            cyan = "#5ef1ff",
          },
        },

        -- Disable or enable colorscheme extensions
        extensions = {
          alpha = true,
          blinkcmp = true,
          cmp = true,
          dashboard = true,
          fzflua = true,
          gitpad = true,
          gitsigns = true,
          grapple = true,
          grugfar = true,
          helpview = true,
          hop = true,
          indentblankline = true,
          kubectl = true,
          lazy = true,
          leap = true,
          markdown = true,
          markview = true,
          mini = true,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          snacks = true,
          telescope = true,
          treesitter = true,
          treesittercontext = true,
          trouble = true,
          whichkey = true,
        },
      })

      -- Apply the colorscheme
      vim.cmd.colorscheme("cyberdream")
    end,
  },
  { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
  {
    "stevearc/aerial.nvim", -- Toggled list of classes, methods etc in current file
    lazy = false,
    opts = {
      attach_mode = "global",
      close_on_select = true,
      layout = {
        min_width = 30,
        default_direction = "prefer_right",
      },
      -- Use nvim-navic icons
      icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰌗 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰕘",
        Interface = "󰕘",
        Function = "󰊕 ",
        Variable = "󰆧 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰌋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = " ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          style_preset = require("bufferline").style_preset.default,
          themable = true,
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,

          -- Enhanced indicator with underline style
          indicator = {
            icon = "▎",
            style = "underline", -- Changed to underline for better visual feedback
          },

          -- Enhanced icons
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "󰅖",
          left_trunc_marker = " ",
          right_trunc_marker = " ",

          -- Buffer display settings
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,

          -- Enhanced LSP diagnostics indicators
          diagnostics = "nvim_lsp",
          diagnostics_update_on_event = true, -- use nvim's diagnostic handler
          -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          -- NOTE: this will be called a lot so don't do any heavy processing here
          custom_filter = function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
              return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
              return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
              return true
            end
            -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
              return true
            end
          end,

          -- Visual enhancements
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          move_wraps_at_ends = false,

          -- Slanted separator style
          separator_style = "padded_slope", -- Already set, keeping slanted tabs
          enforce_regular_tabs = true,      -- Allow slanted tabs to work properly
          always_show_bufferline = true,

          -- Enhanced hover events
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          -- Sidebar offsets for NeoTree and other sidebars
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
            {
              filetype = "Outline",
              text = "Symbols",
              text_align = "center",
              separator = true,
            },
          },

          -- Custom areas for additional functionality
          custom_areas = {
            right = function()
              local result = {}
              local seve = vim.diagnostic.severity
              local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
              local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
              local info = #vim.diagnostic.get(0, { severity = seve.INFO })
              local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

              if error ~= 0 then
                table.insert(result, { text = "  " .. error, link = "DiagnosticError" })
              end

              if warning ~= 0 then
                table.insert(result, { text = "  " .. warning, link = "DiagnosticWarn" })
              end

              if hint ~= 0 then
                table.insert(result, { text = "  " .. hint, link = "DiagnosticHint" })
              end

              if info ~= 0 then
                table.insert(result, { text = "  " .. info, link = "DiagnosticInfo" })
              end
              return result
            end,
          },
        },

        -- Enhanced highlights for better visual appeal
        highlights = {
          fill = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          background = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          tab = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          tab_selected = {
            fg = "#cdd6f4",
            bg = "#1e1e2e",
          },
          tab_separator = {
            fg = "#181825",
            bg = "#181825",
          },
          tab_separator_selected = {
            fg = "#181825",
            bg = "#1e1e2e",
          },
          tab_close = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          close_button = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          close_button_visible = {
            fg = "#7c7d83",
            bg = "#313244",
          },
          close_button_selected = {
            fg = "#f38ba8",
            bg = "#1e1e2e",
          },
          buffer_visible = {
            fg = "#cdd6f4",
            bg = "#313244",
          },
          buffer_selected = {
            fg = "#cdd6f4",
            bg = "#1e1e2e",
            bold = true,
            italic = false,
          },
          numbers = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          numbers_visible = {
            fg = "#7c7d83",
            bg = "#313244",
          },
          numbers_selected = {
            fg = "#cdd6f4",
            bg = "#1e1e2e",
            bold = true,
            italic = false,
          },
          diagnostic = {
            fg = "#7c7d83",
            bg = "#181825",
          },
          diagnostic_visible = {
            fg = "#7c7d83",
            bg = "#313244",
          },
          diagnostic_selected = {
            fg = "#fab387",
            bg = "#1e1e2e",
            bold = true,
            italic = false,
          },
          hint = {
            fg = "#94e2d5",
            sp = "#94e2d5",
            bg = "#181825",
          },
          hint_visible = {
            fg = "#94e2d5",
            bg = "#313244",
          },
          hint_selected = {
            fg = "#94e2d5",
            bg = "#1e1e2e",
            sp = "#94e2d5",
            bold = true,
            italic = false,
          },
          hint_diagnostic = {
            fg = "#94e2d5",
            sp = "#94e2d5",
            bg = "#181825",
          },
          hint_diagnostic_visible = {
            fg = "#94e2d5",
            bg = "#313244",
          },
          hint_diagnostic_selected = {
            fg = "#94e2d5",
            bg = "#1e1e2e",
            sp = "#94e2d5",
            bold = true,
            italic = false,
          },
          info = {
            fg = "#89b4fa",
            sp = "#89b4fa",
            bg = "#181825",
          },
          info_visible = {
            fg = "#89b4fa",
            bg = "#313244",
          },
          info_selected = {
            fg = "#89b4fa",
            bg = "#1e1e2e",
            sp = "#89b4fa",
            bold = true,
            italic = false,
          },
          info_diagnostic = {
            fg = "#89b4fa",
            sp = "#89b4fa",
            bg = "#181825",
          },
          info_diagnostic_visible = {
            fg = "#89b4fa",
            bg = "#313244",
          },
          info_diagnostic_selected = {
            fg = "#89b4fa",
            bg = "#1e1e2e",
            sp = "#89b4fa",
            bold = true,
            italic = false,
          },
          warning = {
            fg = "#fab387",
            sp = "#fab387",
            bg = "#181825",
          },
          warning_visible = {
            fg = "#fab387",
            bg = "#313244",
          },
          warning_selected = {
            fg = "#fab387",
            bg = "#1e1e2e",
            sp = "#fab387",
            bold = true,
            italic = false,
          },
          warning_diagnostic = {
            fg = "#fab387",
            sp = "#fab387",
            bg = "#181825",
          },
          warning_diagnostic_visible = {
            fg = "#fab387",
            bg = "#313244",
          },
          warning_diagnostic_selected = {
            fg = "#fab387",
            bg = "#1e1e2e",
            sp = "#fab387",
            bold = true,
            italic = false,
          },
          error = {
            fg = "#f38ba8",
            sp = "#f38ba8",
            bg = "#181825",
          },
          error_visible = {
            fg = "#f38ba8",
            bg = "#313244",
          },
          error_selected = {
            fg = "#f38ba8",
            bg = "#1e1e2e",
            sp = "#f38ba8",
            bold = true,
            italic = false,
          },
          error_diagnostic = {
            fg = "#f38ba8",
            sp = "#f38ba8",
            bg = "#181825",
          },
          error_diagnostic_visible = {
            fg = "#f38ba8",
            bg = "#313244",
          },
          error_diagnostic_selected = {
            fg = "#f38ba8",
            bg = "#1e1e2e",
            sp = "#f38ba8",
            bold = true,
            italic = false,
          },
          modified = {
            fg = "#fab387",
            bg = "#181825",
          },
          modified_visible = {
            fg = "#fab387",
            bg = "#313244",
          },
          modified_selected = {
            fg = "#fab387",
            bg = "#1e1e2e",
          },
          duplicate_selected = {
            fg = "#7c7d83",
            bg = "#1e1e2e",
            italic = true,
          },
          duplicate_visible = {
            fg = "#7c7d83",
            bg = "#313244",
            italic = true,
          },
          duplicate = {
            fg = "#7c7d83",
            bg = "#181825",
            italic = true,
          },
          separator_selected = {
            fg = "#1e1e2e",
            bg = "#1e1e2e",
          },
          separator_visible = {
            fg = "#313244",
            bg = "#313244",
          },
          separator = {
            fg = "#181825",
            bg = "#181825",
          },
          indicator_visible = {
            fg = "#313244",
            bg = "#313244",
          },
          indicator_selected = {
            fg = "#89b4fa",
            bg = "#1e1e2e",
          },
          pick_selected = {
            fg = "#f38ba8",
            bg = "#1e1e2e",
            bold = true,
            italic = false,
          },
          pick_visible = {
            fg = "#f38ba8",
            bg = "#313244",
            bold = true,
            italic = false,
          },
          pick = {
            fg = "#f38ba8",
            bg = "#181825",
            bold = true,
            italic = false,
          },
          offset_separator = {
            fg = "#45475a",
            bg = "#181825",
          },
        },
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,                                     -- #RGB hex codes
          RRGGBB = true,                                  -- #RRGGBB hex codes
          names = true,                                   -- "Name" codes like Blue or blue
          RRGGBBAA = false,                               -- #RRGGBBAA hex codes
          AARRGGBB = true,                                -- 0xAARRGGBB hex codes
          rgb_fn = false,                                 -- CSS rgb() and rgba() functions
          hsl_fn = false,                                 -- CSS hsl() and hsla() functions
          css = false,                                    -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false,                                 -- Enable all CSS *functions*: rgb_fn, hsl_fn
          mode = "background",                            -- Set the display mode.
          tailwind = false,                               -- Enable tailwind colors
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          always_update = false,
        },
        buftypes = {},
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      animate = { enabled = true },
      bigfile = { enabled = true },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = true },
      lazygit = { enabled = true },
      notify = { enabled = true },
      quickfix = { enabled = true },
      win = { enabled = true },
      dashboard = {
        sections = {
          { section = "header" },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            height = 5,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          trim_prompt = true,
          title_pos = "left",
          insert_only = true,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
          buf_options = {},
          win_options = {
            wrap = false,
            list = true,
            listchars = "precedes:…,extends:…",
            sidescrolloff = 0,
          },
          mappings = {
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },
          override = function(conf)
            return conf
          end,
          get_config = nil,
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
          trim_prompt = true,
          telescope = nil,
          fzf = {
            window = {
              width = 0.5,
              height = 0.4,
            },
          },
          fzf_lua = {
            winopts = {
              height = 0.5,
              width = 0.5,
            },
          },
          nui = {
            position = "50%",
            size = nil,
            relative = "editor",
            border = {
              style = "rounded",
            },
            buf_options = {
              swapfile = false,
              filetype = "DressingSelect",
            },
            win_options = {
              winblend = 0,
            },
            max_width = 80,
            max_height = 40,
            min_width = 40,
            min_height = 10,
          },
          builtin = {
            show_numbers = true,
            border = "rounded",
            relative = "editor",
            buf_options = {},
            win_options = {
              cursorline = true,
              winblend = 0,
            },
            width = nil,
            max_width = { 140, 0.8 },
            min_width = { 40, 0.2 },
            height = nil,
            max_height = 0.9,
            min_height = { 10, 0.2 },
            mappings = {
              ["<Esc>"] = "Close",
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            override = function(conf)
              return conf
            end,
          },
          format_item_override = {},
          get_config = nil,
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        progress = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      notify = {
        enabled = true,
        view = "notify",
        opts = {
          timeout = 3000,
          max_height = 10,
          max_width = 80,
          render = "compact",
          stages = "fade_in_slide_out",
          background_colour = "#000000",
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn",  "",                                                                            desc = "+noice" },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "ojroques/nvim-bufdel",
    config = function()
      require("bufdel").setup({
        next = "tabs",
        quit = true,
      })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    recommended = true,
    desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
    event = "BufReadPre",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        -- custom LazyVim option to enable the tailwind integration
        tailwind = {
          enabled = true,
          ft = {
            "astro",
            "css",
            "heex",
            "html",
            "html-eex",
            "javascript",
            "javascriptreact",
            "rust",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
          },
          -- full: the whole css class will be highlighted
          -- compact: only the color will be highlighted
          style = "full",
        },
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]",
            group = function(_, _, data)
              ---@type string
              local match = data.full_match
              local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
              local hex_color = "#" .. r .. r .. g .. g .. b .. b

              return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
            end,
            extmark_opts = { priority = 2000 },
          },
        },
      }
    end,
    config = function(_, opts)
      if type(opts.tailwind) == "table" and opts.tailwind.enabled then
        -- Disable Tailwind integration for now to prevent errors
        -- You can re-enable this once you have a proper Tailwind color palette
        opts.tailwind.enabled = false
      end
      require("mini.hipatterns").setup(opts)
    end,
  },
}
