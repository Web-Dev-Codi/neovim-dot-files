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
  {
    "tpope/vim-dadbod",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "stevearc/overseer.nvim",
    version = "*",
    config = function()
      -- Suppress deprecation warnings for now
      local old_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if type(msg) == "string" and msg:match("vim%.validate.*deprecated") then
          return
        end
        return old_notify(msg, level, opts)
      end

      require("overseer").setup({
        templates = { "builtin", "user.cpp_build" },
        strategy = {
          "toggleterm",
          direction = "horizontal",
          autos_croll = true,
          quit_on_exit = "success",
        },
        component_aliases = {
          default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            { "on_complete_notify", on_change = true },
            "on_complete_dispose",
          },
        },
      })

      vim.keymap.set("n", "<leader>oo", "<cmd>OverseerOpen<cr>")
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>")
      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>")
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        severity = nil,
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        cycle_results = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>", "<2-leftmouse>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = { "o" },
          toggle_mode = "m",
          switch_severity = "s",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          open_code_href = "c",
          close_folds = { "zM", "zm" },
          open_folds = { "zR", "zr" },
          toggle_fold = { "zA", "za" },
          previous = "k",
          next = "j",
          help = "?",
        },
        multiline = true,
        indent_lines = true,
        win_config = { border = "single" },
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        auto_jump = { "lsp_definitions" },
        include_declaration = {
          "lsp_references",
          "lsp_implementations",
          "lsp_definitions",
        },
        signs = {
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "",
        },
        use_diagnostic_signs = false,
      })

      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
      end)
      vim.keymap.set("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
      end)
      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end)
      vim.keymap.set("n", "<leader>xq", function()
        require("trouble").toggle("quickfix")
      end)
      vim.keymap.set("n", "<leader>xl", function()
        require("trouble").toggle("loclist")
      end)
      vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
      end)
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
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = false,
        auto_session_enable_last_session = false,
        auto_save_enabled = false,
        auto_restore_enabled = false,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      })
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
        pre_save = nil,
        save_empty = false,
      })

      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end)
      vim.keymap.set("n", "<leader>ql", function()
        require("persistence").load({ last = true })
      end)
      vim.keymap.set("n", "<leader>qd", function()
        require("persistence").stop()
      end)
    end,
  },
}
