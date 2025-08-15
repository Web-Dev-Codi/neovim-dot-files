return {
  "nvim-zh/colorful-winsep.nvim",
  -- Defer activation to avoid running during early UI events
  event = { "VeryLazy" },
  config = function()
    require("colorful-winsep").setup({
      -- highlight for Window separator
      hi = {
        bg = "#16161E",
        fg = "#39FF14",
      },
      -- This plugin will not be activated for filetype in the following table.
      no_exec_files = {
        "packer",
        "TelescopePrompt",
        "mason",
        "CompetiTest",
        "NvimTree",
        "lazygit",
        -- common popup/aux buffers that can be closed frequently
        "noice",
        "notify",
        "Nui",
        "neo-tree",
        "toggleterm",
        "Outline",
        "lazy",
      },
      -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      -- #70: https://github.com/nvim-zh/colorful-winsep.nvim/discussions/70
      only_line_seq = true,
      -- Smooth moving switch
      smooth = true,
      exponential_smoothing = true,
      anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
      },
    })

    -- Prevent E242: Can't split a window while closing another
    -- by disabling winsep during WinClosed and re-enabling on next tick
    local aug = vim.api.nvim_create_augroup("ColorfulWinsepGuards", { clear = true })
    vim.api.nvim_create_autocmd("WinClosed", {
      group = aug,
      callback = function()
        pcall(vim.cmd, "Winsep disable")
        vim.schedule(function()
          pcall(vim.cmd, "Winsep enable")
        end)
      end,
      desc = "Guard colorful-winsep against window teardown",
    })
  end,
}
