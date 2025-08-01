return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy", -- Load after startup
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier",
          "prettierd",
          "stylua",
          "black",
          "isort",
          "shfmt",

          -- Linters
          "eslint_d",
          "pylint",
          "shellcheck",
          "markdownlint",
          "yamllint",
          "jsonlint",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
  {
    "mattn/emmet-vim",
    ft = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    config = function()
      vim.g.user_emmet_leader_key = "<C-Z>"
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
      }
    end,
  },
  {
    "peitalin/vim-jsx-typescript",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "vuki656/package-info.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4142",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "npm",
      })
    end,
  },
  -- {
  --   "stevearc/overseer.nvim",
  --   version = "*",
  --   config = function()
  --     -- Suppress deprecation warnings for now
  --     local old_notify = vim.notify
  --     vim.notify = function(msg, level, opts)
  --       if type(msg) == "string" and msg:match("vim%.validate.*deprecated") then
  --         return
  --       end
  --       return old_notify(msg, level, opts)
  --     end
  --
  --     require("overseer").setup({
  --       templates = { "builtin", "user.cpp_build" },
  --       strategy = {
  --         "toggleterm",
  --         direction = "horizontal",
  --         autos_croll = true,
  --         quit_on_exit = "success",
  --       },
  --       component_aliases = {
  --         default = {
  --           { "display_duration", detail_level = 2 },
  --           "on_output_summarize",
  --           "on_exit_set_status",
  --           { "on_complete_notify", on_change = true },
  --           "on_complete_dispose",
  --         },
  --       },
  --     })
  --
  --     vim.keymap.set("n", "<leader>oo", "<cmd>OverseerOpen<cr>")
  --     vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>")
  --     vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>")
  --   end,
  -- },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        -- Trouble v3 configuration
        modes = {
          diagnostics = {
            mode = "diagnostics",
            preview = {
              type = "split",
              relative = "win",
              position = "right",
              size = 0.3,
            },
          },
        },
        icons = {
          indent = {
            top = "│ ",
            middle = "├╴",
            last = "└╴",
            fold_open = " ",
            fold_closed = " ",
            ws = "  ",
          },
          folder_closed = " ",
          folder_open = " ",
          kinds = {
            Array = " ",
            Boolean = "󰨙 ",
            Class = " ",
            Constant = "󰏿 ",
            Constructor = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Function = "󰊕 ",
            Interface = " ",
            Key = " ",
            Method = "󰊕 ",
            Module = " ",
            Namespace = "󰦮 ",
            Null = " ",
            Number = "󰎠 ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            String = " ",
            Struct = "󰆼 ",
            TypeParameter = " ",
            Variable = "󰀫 ",
          },
        },
      })

      -- Keybindings are now handled by which-key.lua with the new v3 API
      -- No need for manual keybindings here as they're defined in which-key
    end,
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   config = function()
  --     require("lint").linters_by_ft = {
  --       javascript = { "prettierd" },
  --       typescript = { "prettierd" },
  --       javascriptreact = { "prettierd" },
  --       typescriptreact = { "prettierd" },
  --       python = { "pylint" },
  --       lua = { "luacheck" },
  --       sh = { "shellcheck" },
  --       bash = { "shellcheck" },
  --       zsh = { "shellcheck" },
  --       markdown = { "markdownlint" },
  --       yaml = { "yamllint" },
  --       json = { "jsonlint" },
  --     }

  --     vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  --       callback = function()
  --         require("lint").try_lint()
  --       end,
  --     })
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          yaml = { { "prettierd", "prettier" } },
          markdown = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  -- {
  --   "rmagatti/auto-session",
  --   config = function()
  --     require("auto-session").setup({
  --       log_level = "error",
  --       auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --       auto_session_use_git_branch = false,
  --       auto_session_enable_last_session = false,
  --       auto_save_enabled = false,
  --       auto_restore_enabled = false,
  --       auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  --     })
  --   end,
  -- },
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require("persistence").setup({
  --       dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  --       options = { "buffers", "curdir", "tabpages", "winsize" },
  --       pre_save = nil,
  --       save_empty = false,
  --     })
  --
  --     vim.keymap.set("n", "<leader>qs", function()
  --       require("persistence").load()
  --     end)
  --     vim.keymap.set("n", "<leader>ql", function()
  --       require("persistence").load({ last = true })
  --     end)
  --     vim.keymap.set("n", "<leader>qd", function()
  --       require("persistence").stop()
  --     end)
  --   end,
  -- },
}
