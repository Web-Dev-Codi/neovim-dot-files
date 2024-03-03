return {
  "romgrk/barbar.nvim",
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = true,
    insert_at_start = true,
    clickable = true,
  },
}
