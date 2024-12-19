return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
    },
    preset = "classic",
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
