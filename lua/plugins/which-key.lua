return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern",
        delay = 1000,
        filter = function(mapping)
          -- exclude mappings without a description
          return mapping.desc and mapping.desc ~= ""
        end,
        spec = {},
        notify = true,
        triggers = {
          { "<auto>", mode = "nxsot" },
        },
        defer = function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>"
        end,
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = false,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        win = {
          border = "rounded",
          padding = { 1, 2 },
        },
        layout = {
          width = { min = 20 },
          spacing = 3,
        },
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        sort = { "local", "order", "group", "alphanum", "mod" },
        expand = 0,
        replace = {
          ["<leader>"] = "SPC",
          ["<cr>"] = "RET",
          ["<tab>"] = "TAB",
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          mappings = true,
          rules = {},
          colors = true,
          keys = {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            D = "󰘳 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "󰁮",
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫",
            F2 = "󱊬",
            F3 = "󱊭",
            F4 = "󱊮",
            F5 = "󱊯",
            F6 = "󱊰",
            F7 = "󱊱",
            F8 = "󱊲",
            F9 = "󱊳",
            F10 = "󱊴",
            F11 = "󱊵",
            F12 = "󱊶",
          },
        },
        show_help = true,
        show_keys = true,
        disable = {
          ft = { "TelescopePrompt" },
        },
      })

      -- Use the new spec format with wk.add()
      wk.add({
        -- File operations
        { "<leader>f",  group = "file" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                                           desc = "Find File" },
        { "<leader>fn", "<cmd>enew<cr>",                                                           desc = "New File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                             desc = "Open Recent File" },

        -- Debug operations
        { "<leader>d",  group = "debug" },
        { "<leader>dC", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", desc = "Conditional Breakpoint" },
        { "<leader>dE", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>",        desc = "Evaluate Input" },
        { "<leader>dR", "<cmd>lua require'dap'.run_to_cursor()<cr>",                               desc = "Run to Cursor" },
        { "<leader>dS", "<cmd>lua require'dap.ui.widgets'.scopes()<cr>",                           desc = "Scopes" },
        { "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>",                                    desc = "Toggle UI" },
        { "<leader>db", "<cmd>lua require'dap'.step_back()<cr>",                                   desc = "Step Back" },
        { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>",                                    desc = "Continue" },
        { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>",                                  desc = "Disconnect" },
        { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>",                                      desc = "Evaluate" },
        { "<leader>dg", "<cmd>lua require'dap'.session()<cr>",                                     desc = "Get Session" },
        { "<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>",                            desc = "Hover Variables" },
        { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",                                   desc = "Step Into" },
        { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>",                                   desc = "Step Over" },
        { "<leader>dp", "<cmd>lua require'dap'.pause.toggle()<cr>",                                desc = "Pause" },
        { "<leader>dq", "<cmd>lua require'dap'.close()<cr>",                                       desc = "Quit" },
        { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>",                                 desc = "Toggle Repl" },
        { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>",                                    desc = "Start" },
        { "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                           desc = "Toggle Breakpoint" },
        { "<leader>du", "<cmd>lua require'dap'.step_out()<cr>",                                    desc = "Step Out" },
        { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>",                                   desc = "Terminate" },

        -- Git operations
        { "<leader>g",  group = "git" },
        { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>",                             desc = "Next Hunk" },
        { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",                             desc = "Prev Hunk" },
        { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                            desc = "Blame" },
        { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                          desc = "Preview Hunk" },
        { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                            desc = "Reset Hunk" },
        { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                          desc = "Reset Buffer" },
        { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                            desc = "Stage Hunk" },
        { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                       desc = "Undo Stage Hunk" },
        { "<leader>go", "<cmd>Telescope git_status<cr>",                                           desc = "Open changed file" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>",                                         desc = "Checkout branch" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>",                                          desc = "Checkout commit" },
        { "<leader>gC", "<cmd>Telescope git_bcommits<cr>",                                         desc = "Checkout commit(for current file)" },
        { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                         desc = "Git Diff" },

        -- LSP operations
        { "<leader>l",  group = "LSP" },
        { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",                                  desc = "Code Action" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>",                                  desc = "Document Diagnostics" },
        { "<leader>lw", "<cmd>Telescope diagnostics<cr>",                                          desc = "Workspace Diagnostics" },
        { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>",                             desc = "Format" },
        { "<leader>li", "<cmd>LspInfo<cr>",                                                        desc = "Info" },
        { "<leader>lI", "<cmd>LspInstallInfo<cr>",                                                 desc = "Installer Info" },
        { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",                             desc = "Next Diagnostic" },
        { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",                             desc = "Prev Diagnostic" },
        { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",                                     desc = "CodeLens Action" },
        { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>",                                desc = "Quickfix" },
        { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",                                       desc = "Rename" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",                                 desc = "Document Symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                        desc = "Workspace Symbols" },

        -- Search operations
        { "<leader>s",  group = "search" },
        { "<leader>sb", "<cmd>Telescope git_branches<cr>",                                         desc = "Checkout branch" },
        { "<leader>sc", "<cmd>Telescope colorscheme<cr>",                                          desc = "Colorscheme" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                            desc = "Find Help" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                            desc = "Man Pages" },
        { "<leader>sr", "<cmd>Telescope oldfiles<cr>",                                             desc = "Open Recent File" },
        { "<leader>sR", "<cmd>Telescope registers<cr>",                                            desc = "Registers" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                              desc = "Keymaps" },
        { "<leader>sC", "<cmd>Telescope commands<cr>",                                             desc = "Commands" },

        -- Terminal operations
        { "<leader>t",  group = "terminal" },
        { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>",                                             desc = "Node" },
        { "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>",                                             desc = "NCDU" },
        { "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>",                                             desc = "Htop" },
        { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>",                                           desc = "Python" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",                                     desc = "Float" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>",                        desc = "Horizontal" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",                          desc = "Vertical" },
      })
    end,
  },
}
