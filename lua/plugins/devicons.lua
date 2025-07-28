return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,    -- Load immediately to prevent icon errors
    priority = 1500, -- Very high priority to load before other plugins
    init = function()
      -- Pre-load the module to ensure it's available
      require("nvim-web-devicons")
    end,
    config = function()
      require("nvim-web-devicons").setup({
        -- your personalize color can be picked
        color_icons = true,
        -- globally enable default icons (default to false)
        -- will get overridden by `get_icons` option
        default = true,
        -- globally enable "strict" selection of icons - icon will be looked up in
        -- different tables, first by filename, and if not found by extension; this
        -- prevents cases when file doesn't have any extension but still gets some icon
        -- because its name happened to match some extension (default to false)
        strict = true,
        -- same as `override` but specifically for overrides by filename
        -- takes effect when `strict` is true
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        -- same as `override` but specifically for overrides by extension
        -- takes effect when `strict` is true
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      })
    end,
  },
}
