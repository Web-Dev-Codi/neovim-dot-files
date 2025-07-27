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
      })

      wk.add({
        -- File operations (Telescope)
        { "<leader>f",  group = "file" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                    desc = "Find File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                      desc = "Recent Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",                     desc = "Find Text" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",                       desc = "Find Buffer" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",                     desc = "Help Tags" },
        { "<leader>fc", "<cmd>Telescope commands<cr>",                      desc = "Commands" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
        { "<leader>fn", "<cmd>enew<cr>",                                    desc = "New File" },

        -- Buffer operations
        { "<leader>b",  group = "buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>",                                 desc = "Delete Buffer" },
        { "<leader>bn", "<cmd>bnext<cr>",                                   desc = "Next Buffer" },
        { "<leader>bp", "<cmd>bprevious<cr>",                               desc = "Previous Buffer" },
        { "<leader>bb", "<cmd>Telescope buffers<cr>",                       desc = "Switch Buffer" },

        -- LSP operations
        { "<leader>l",  group = "lsp" },
        { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",           desc = "Code Action" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>",           desc = "Document Diagnostics" },
        { "<leader>lw", "<cmd>Telescope diagnostics<cr>",                   desc = "Workspace Diagnostics" },
        { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>",      desc = "Format" },
        { "<leader>li", "<cmd>LspInfo<cr>",                                 desc = "Info" },
        { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",                desc = "Rename" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document Symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>",         desc = "Workspace Symbols" },

        -- Git operations (Gitsigns)
        { "<leader>g",  group = "git" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>",                     desc = "Blame Line" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",                   desc = "Preview Hunk" },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                     desc = "Reset Hunk" },
        { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>",                   desc = "Reset Buffer" },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",                     desc = "Stage Hunk" },
        { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",                   desc = "Stage Buffer" },
        { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",                desc = "Undo Stage Hunk" },
        { "<leader>gd", "<cmd>Gitsigns diffthis<cr>",                       desc = "Diff This" },

        -- File Explorer
        { "<leader>e",  group = "explorer" },
        { "<leader>ee", "<cmd>NvimTreeToggle<cr>",                          desc = "Toggle Nvim-Tree" },
        { "<leader>ef", "<cmd>NvimTreeFindFile<cr>",                        desc = "Find File in Tree" },
        { "<leader>en", "<cmd>Neotree toggle<cr>",                          desc = "Toggle Neo-Tree" },
        { "<leader>eo", "<cmd>Oil<cr>",                                     desc = "Open Oil" },

        -- Search operations
        { "<leader>s",  group = "search" },
        { "<leader>sb", "<cmd>Telescope buffers<cr>",                       desc = "Search Buffers" },
        { "<leader>sc", "<cmd>Telescope commands<cr>",                      desc = "Search Commands" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>",                     desc = "Search Help" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>",                       desc = "Search Keymaps" },
        { "<leader>sm", "<cmd>Telescope marks<cr>",                         desc = "Search Marks" },
        { "<leader>sr", "<cmd>Telescope registers<cr>",                     desc = "Search Registers" },
        { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Search Symbols" },
        { "<leader>st", "<cmd>Telescope live_grep<cr>",                     desc = "Search Text" },

        -- Diagnostics/Trouble
        { "<leader>x",  group = "diagnostics" },
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },

        -- Terminal
        { "<leader>t",  group = "terminal" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              desc = "Float Terminal" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",   desc = "Vertical Terminal" },

        -- Code operations
        { "<leader>c",  group = "code" },
        { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>",           desc = "Code Action" },
        { "<leader>cf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>",      desc = "Format Code" },
        { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>",                desc = "Rename" },

        -- Mason
        { "<leader>m",  group = "mason" },
        { "<leader>mm", "<cmd>Mason<cr>",                                   desc = "Mason" },
        { "<leader>mi", "<cmd>MasonInstall<cr>",                            desc = "Mason Install" },
        { "<leader>mu", "<cmd>MasonUpdate<cr>",                             desc = "Mason Update" },

        -- Window operations
        { "<leader>w",  group = "window" },
        { "<leader>wh", "<C-w>h",                                           desc = "Go to Left Window" },
        { "<leader>wj", "<C-w>j",                                           desc = "Go to Lower Window" },
        { "<leader>wk", "<C-w>k",                                           desc = "Go to Upper Window" },
        { "<leader>wl", "<C-w>l",                                           desc = "Go to Right Window" },
        { "<leader>ws", "<C-w>s",                                           desc = "Split Window Below" },
        { "<leader>wv", "<C-w>v",                                           desc = "Split Window Right" },
        { "<leader>wd", "<C-w>c",                                           desc = "Delete Window" },
        { "<leader>wo", "<C-w>o",                                           desc = "Delete Other Windows" },

        -- Quit operations
        { "<leader>q",  group = "quit" },
        { "<leader>qq", "<cmd>qa<cr>",                                      desc = "Quit All" },
        { "<leader>qw", "<cmd>wqa<cr>",                                     desc = "Save and Quit All" },
        { "<leader>q!", "<cmd>qa!<cr>",                                     desc = "Force Quit All" },

        -- UI toggles
        { "<leader>u",  group = "ui" },
        { "<leader>ub", "<cmd>set background=dark<cr>",                     desc = "Dark Background" },
        { "<leader>ul", "<cmd>set number!<cr>",                             desc = "Toggle Line Numbers" },
        { "<leader>ur", "<cmd>set relativenumber!<cr>",                     desc = "Toggle Relative Numbers" },
        { "<leader>us", "<cmd>set spell!<cr>",                              desc = "Toggle Spelling" },
        { "<leader>uw", "<cmd>set wrap!<cr>",                               desc = "Toggle Wrap" },
        { "<leader>uc", "<cmd>set conceallevel=2<cr>",                      desc = "Set Conceal Level" },

        -- Alpha dashboard
        { "<leader>a",  group = "alpha" },
        { "<leader>aa", "<cmd>Alpha<cr>",                                   desc = "Alpha Dashboard" },
      })
    end,
  },
}
