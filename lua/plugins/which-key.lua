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
        -- Basic operations
        { "<C-s>", "<cmd>w<CR>", desc = "Save File", mode = "n" },
        { "<C-s>", "<Esc><cmd>w<CR>", desc = "Save File", mode = "i" },
        { "<C-q>", "<cmd>q<CR>", desc = "Quit" },
        { "x", '"_x', desc = "Delete char (no register)" },

        -- Navigation and scrolling
        { "<C-d>", "<C-d>zz", desc = "Scroll down and center" },
        { "<C-u>", "<C-u>zz", desc = "Scroll up and center" },
        { "n", "nzzzv", desc = "Next search result (centered)" },
        { "N", "Nzzzv", desc = "Previous search result (centered)" },

        -- Window resizing
        { "<Up>", ":resize -2<CR>", desc = "Resize window up" },
        { "<Down>", ":resize +2<CR>", desc = "Resize window down" },
        { "<Left>", ":vertical resize -2<CR>", desc = "Resize window left" },
        { "<Right>", ":vertical resize +2<CR>", desc = "Resize window right" },

        -- Window navigation
        { "<C-k>", ":wincmd k<CR>", desc = "Move to window above" },
        { "<C-j>", ":wincmd j<CR>", desc = "Move to window below" },
        { "<C-h>", ":wincmd h<CR>", desc = "Move to window left" },
        { "<C-l>", ":wincmd l<CR>", desc = "Move to window right" },

        -- Buffer navigation
        { "<Tab>", ":bnext<CR>", desc = "Next buffer" },
        { "<S-Tab>", ":bprevious<CR>", desc = "Previous buffer" },

        -- Visual mode mappings
        {
          "<",
          "<gv",
          desc = "Indent left (stay in visual)",
          mode = "v",
        },
        {
          ">",
          ">gv",
          desc = "Indent right (stay in visual)",
          mode = "v",
        },
        {
          "p",
          '"_dP',
          desc = "Paste (keep register)",
          mode = "v",
        },
        {
          "J",
          ":m '>+1<CR>gv=gv",
          desc = "Move line down",
          mode = "v",
        },
        {
          "K",
          ":m '<-2<CR>gv=gv",
          desc = "Move line up",
          mode = "v",
        },

        -- Special character mappings
        { "J", "mzJ`z", desc = "Join lines (keep cursor)" },
        { "Q", "<nop>", desc = "Disable Ex mode" },

        -- File operations (Telescope)
        { "<leader>f", group = "file" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Text" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffer" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
        { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },

        -- Buffer operations
        { "<leader>b", group = "buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
        { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
        { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
        { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer" },
        { "<leader>x", ":bdelete!<CR>", desc = "Close Buffer" },
        { "<leader>be", "<cmd>enew<CR>", desc = "New Buffer" },

        -- Window management
        { "<leader>w", group = "window" },
        { "<leader>v", "<C-w>v", desc = "Split Vertically" },
        { "<leader>h", "<C-w>s", desc = "Split Horizontally" },
        { "<leader>se", "<C-w>=", desc = "Equal Window Size" },
        { "<leader>xs", ":close<CR>", desc = "Close Split" },

        -- Tab management
        { "<leader>t", group = "tabs" },
        { "<leader>to", ":tabnew<CR>", desc = "Open New Tab" },
        { "<leader>tx", ":tabclose<CR>", desc = "Close Tab" },
        { "<leader>tn", ":tabn<CR>", desc = "Next Tab" },
        { "<leader>tp", ":tabp<CR>", desc = "Previous Tab" },

        -- Utility
        { "<leader>lw", "<cmd>set wrap!<CR>", desc = "Toggle Line Wrap" },
        { "<leader>sn", "<cmd>noautocmd w<CR>", desc = "Save Without Formatting" },

        -- Session management
        { "<leader>s", group = "session" },
        { "<leader>ss", ":mksession! .session.vim<CR>", desc = "Save Session" },
        { "<leader>sl", ":source .session.vim<CR>", desc = "Load Session" },
        { "<leader>sn", "<cmd>noautocmd w<CR>", desc = "Save Without Formatting" },

        -- Diagnostics
        { "<leader>d", vim.diagnostic.open_float, desc = "Open Diagnostic Float" },
        {
          "<leader>q",
          function()
            vim.cmd("qa!")
          end,
          desc = "Close Buffer or Quit",
        },

        -- MicroPython
        {
          "<leader>mr",
          function()
            require("micropython_nvim").run()
          end,
          desc = "Run MicroPython",
        },
        { "<leader>mx", "<cmd>!chmod +x %<CR>", desc = "Make File Executable" },

        -- Clipboard operations
        { "<leader>y", group = "yank/clipboard" },
        {
          "<leader>y",
          [["+y]],
          desc = "Yank to System Clipboard",
          mode = { "n", "v" },
        },
        {
          "<leader>Y",
          [["+Y]],
          desc = "Yank Line to System Clipboard",
        },
        {
          "<leader>p",
          [['"_dP']],
          desc = "Paste Without Losing Register",
          mode = "x",
        },
        {
          "<leader>D",
          [['"_d]],
          desc = "Delete to Black Hole Register",
          mode = { "n", "v" },
        },

        -- Navigation and search
        {
          "<leader>pv",
          function()
            vim.cmd.Ex()
          end,
          desc = "File Explorer (Ex)",
        },
        { "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Search and Replace Word" },
        { "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", desc = "Tmux Sessionizer" },

        -- Quickfix and Location List
        { "<leader>c", group = "quickfix" },
        { "<leader>cn", "<cmd>cnext<CR>zz", desc = "Next Quickfix Item" },
        { "<leader>cp", "<cmd>cprev<CR>zz", desc = "Previous Quickfix Item" },
        { "<leader>ln", "<cmd>lnext<CR>zz", desc = "Next Location List Item" },
        { "<leader>lp", "<cmd>lprev<CR>zz", desc = "Previous Location List Item" },

        -- CodeCompanion
        { "<leader>a", group = "ai/codecompanion" },
        {
          "<leader>a",
          "<cmd>CodeCompanionActions<cr>",
          desc = "CodeCompanion Actions",
          mode = { "n", "v" },
        },
        {
          "<leader>aa",
          "<cmd>CodeCompanionChat Toggle<cr>",
          desc = "Toggle CodeCompanion Chat",
          mode = { "n", "v" },
        },
        {
          "<leader>ac",
          "<cmd>CodeCompanionChat<cr>",
          desc = "Open CodeCompanion Chat",
          mode = { "n", "v" },
        },
        {
          "<leader>ai",
          function()
            require("codecompanion").prompt("Complete this code", {
              adapter = "code_completion",
              strategy = "inline",
            })
          end,
          desc = "Inline Code Completion",
        },
        { "<leader>ad", "<cmd>CodeCompanionFixDiagnostics<cr>", desc = "Fix LSP Diagnostics" },
        {
          "<leader>as",
          function()
            local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
            local filetype = vim.bo.filetype
            require("codecompanion").chat({
              context = "Current file content:\n```" .. filetype .. "\n" .. content .. "\n```",
            })
          end,
          desc = "Send File to Chat",
        },
        {
          "<leader>al",
          function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
              if result and result.contents then
                local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                require("codecompanion").chat({
                  context = "LSP hover information:\n" .. table.concat(hover_content, "\n"),
                })
              end
            end)
          end,
          desc = "Send LSP Hover to Chat",
        },
        {
          "<leader>am",
          function()
            local models = {
              "qwen2.5vl:32b",
              "codellama:13b",
              "codellama:34b",
              "deepcoder:14b",
              "deepseek-coder:6.7b",
              "deepseek-r1:32b",
              "dolphin3:8b",
              "gpt-oss:20b",
              "llama3.1:8b",
              "llama3.2:3b",
              "mistral-small3.2:latest",
              "qwen3-coder:30b",
              "qwen2.5vl:32b",
            }
            vim.ui.select(models, {
              prompt = "Select model:",
            }, function(choice)
              if choice then
                local codecompanion = require("codecompanion")
                local config = codecompanion.config or {}
                if config.adapters and config.adapters.ollama then
                  if type(config.adapters.ollama) == "function" then
                    local adapter = config.adapters.ollama()
                    if adapter and adapter.schema and adapter.schema.model then
                      adapter.schema.model.default = choice
                    end
                  else
                    if config.adapters.ollama.schema and config.adapters.ollama.schema.model then
                      config.adapters.ollama.schema.model.default = choice
                    end
                  end
                end
                print("Switched to model: " .. choice)
              end
            end)
          end,
          desc = "Switch Model",
        },

        -- Code-specific actions (visual mode)
        {
          "<leader>cr",
          "",
          desc = "Code Review",
          mode = "v",
        },
        {
          "<leader>ct",
          "",
          desc = "Generate Tests",
          mode = "v",
        },
        {
          "<leader>ce",
          "",
          desc = "Explain Code",
          mode = "v",
        },
        {
          "<leader>cf",
          "",
          desc = "Fix Code",
          mode = "v",
        },
        {
          "<leader>co",
          "",
          desc = "Optimize Code",
          mode = "v",
        },
        {
          "<leader>cc",
          "",
          desc = "Add Comments",
          mode = "v",
        },
        {
          "<leader>cd",
          "",
          desc = "Generate Documentation",
          mode = "v",
        },

        -- LSP operations
        { "<leader>l", group = "lsp" },
        { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
        { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format()
          end,
          desc = "Format Code",
        },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
        { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

        -- Git operations (Gitsigns + LazyGit)
        { "<leader>g", group = "git" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
        { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
        { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
        { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
        { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>gc", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
        { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },

        -- File Explorer
        { "<leader>e", group = "explorer" },
        { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Nvim-Tree" },
        { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Find File in Tree" },
        { "<leader>en", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-Tree" },
        { "<leader>eo", "<cmd>Oil<cr>", desc = "Open Oil" },

        -- Search operations
        { "<leader>/", group = "search" },
        { "<leader>/f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>/g", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        { "<leader>/b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>/h", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },

        -- Trouble
        { "<leader>x", group = "trouble" },
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },

        -- Terminal
        { "<leader>t", group = "terminal" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
      })
    end,
  },
}
