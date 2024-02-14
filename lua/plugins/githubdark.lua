return {
  "projekt0n/github-nvim-theme",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("github-theme").setup {
      options = {
        transparent = true, -- Disable setting background
        terminal_colors = true,
        styles = { -- Style to be applied to different syntax groups
          comments = "bold", -- Value is any valid attr-list value `:help attr-list`
          functions = "italic",
          keywords = "italic",
          variables = "bold",
          conditionals = "bold",
          constants = "italic",
          numbers = "bold",
          operators = "bold",
          strings = "italic,bold",
          types = "bold",
        },
        palette = {
          black = " #000000",
          red = "#FF0000",
          green = "#4CAF50",
          yellow = "#FFEB3B",
          blue = "#2196F3",
          magenta = "#9C27B0",
          cyan = "#00FFFF",
          white = "#FFFFFF",
          orange = "#FFA500",
          pink = "#FFC0CB",
          comment = "#FFFFFF",
          bg0 = "",
          bg1 = "",
          bg2 = "",
          bg3 = "",
          bg4 = "",
          fg0 = "" ,
          fg1  ="",
          fg2 = "",
          fg3 = "",
          sel0 = "",
          sel1 = "",
          sel2 = "",

        },
        specs = {
          -- As with palettes, the values defined under `all` will be applied to every style.
          all = {
            syntax = {
              -- Specs allow you to define a value using either a color or template. If the string does
              -- start with `#` the string will be used as the path of the palette table. Defining just
              -- a color uses the base version of that color.
              keyword = "green",
              builtin0 = "red",
              -- Adding either `.bright` will change the value
              conditional = "magenta",
              number = "orange",
            },
          },
        },
      },
    }

    vim.cmd "colorscheme github_dark"
  end,
}
