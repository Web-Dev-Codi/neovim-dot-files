return {
  "folke/neoconf.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("neoconf").setup {
      -- override any of the default settings here
    }
  end,
}
