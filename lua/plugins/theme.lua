return {
  "craftzdog/solarized-osaka.nvim",
  priority = 1000, -- Ensure it loads first
  config = function()
    require("solarized-osaka").setup {
      vim.cmd "colorscheme solarized-osaka",
    }
  end,
}
