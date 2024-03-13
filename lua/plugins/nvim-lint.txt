return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      markdown = { "vale" },
      javascript = { "quick-lint-js" },
      html = { "tidy" },
    }
  end,
}
