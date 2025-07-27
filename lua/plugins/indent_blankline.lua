return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    local api = vim.api
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
      "CursorColumn",
      "Whitespace",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)
    local exclude_ft = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha", "dashboard" }
    ---@diagnostic disable-next-line: inject-field
    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup({
      indent = {
        highlight = highlight,
        -- -- U+2502 may also be a good choice, it will be on the middle of cursor.
        -- -- U+250A is also a good choice
      },
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      scope = {
        highlight = highlight,
      },
      exclude = {
        filetypes = exclude_ft,
        buftypes = { "terminal" },
      },
    })
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    local gid = api.nvim_create_augroup("indent_blankline", { clear = true })
    api.nvim_create_autocmd("InsertEnter", {
      pattern = "*",
      group = gid,
      command = "IBLDisable",
    })

    api.nvim_create_autocmd("InsertLeave", {
      pattern = "*",
      group = gid,
      callback = function()
        if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
          vim.cmd([[IBLEnable]])
        end
      end,
    })
  end,
}
