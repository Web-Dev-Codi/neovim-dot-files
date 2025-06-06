return {
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>M",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
    opts = {
      hint_config = {
        position = "bottom-right",
      },
      generate_hints = {
        normal = true,
        insert = true,
        extend = true,
        config = {
          column_count = 1,
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local function is_active()
        local ok, hydra = pcall(require, "hydra.statusline")
        return ok and hydra.is_active()
      end

      local function get_name()
        local ok, hydra = pcall(require, "hydra.statusline")
        if ok then
          return hydra.get_name()
        end
        return ""
      end

      table.insert(opts.sections.lualine_b, { get_name, cond = is_active })
    end,
  },
}
