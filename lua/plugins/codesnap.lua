return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  keys = {
    { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
  },
  opts = {
    save_path = "~/Pictures",
    mac_window_bar = true,
    title = "",
    code_font_family = "",
    watermark_font_family = "",
    bg_theme = "default",
    breadcrumbs_separator = "/",
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = false,
    watermark = "CodeConduit",
  },
}
