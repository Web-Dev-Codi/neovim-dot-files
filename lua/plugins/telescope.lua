return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  ops = {
    extensions = {
      aerial = {
        -- Set the width of the first two columns (the second
        -- is relevant only when show_columns is set to 'both')
        col1_width = 4,
        col2_width = 30,
        -- How to format the symbols
        format_symbol = function(symbol_path, filetype)
          if filetype == "json" or filetype == "yaml" then
            return table.concat(symbol_path, ".")
          else
            return symbol_path[#symbol_path]
          end
        end,
        -- Available modes: symbols, lines, both
        show_columns = "both",
      },
    },
  },
}
