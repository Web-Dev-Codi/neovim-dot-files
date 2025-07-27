return {
  -- Configure lsp-zero FIRST before any individual servers
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      -- LSP servers configuration
      local lspconfig = require("lspconfig")
      -- Use blink.cmp capabilities instead of cmp_nvim_lsp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        -- TypeScript/JavaScript - use ts_ls only (remove biome to avoid conflicts)
        ts_ls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          },
        },
        emmet_ls = {
          filetypes = { "html", "css", "scss" }, -- Remove JS/TS to avoid conflicts with ts_ls
        },
        html = {},
        cssls = {},
        jsonls = {},
        tailwindcss = {},
        bashls = {},
        dockerls = {},
        yamlls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>vws", function()
          vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
          vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.goto_prev()
        end, opts)
        vim.keymap.set("n", "<leader>vca", function()
          vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>vrr", function()
          vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>vrn", function()
          vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
          vim.lsp.buf.signature_help()
        end, opts)
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },

    -- Additional LSP configuration
    opts = {
      on_attach = function(client, bufnr)
        -- LSP Diagnostics context helper
        local function get_lsp_diagnostics_context()
          local diagnostics = vim.diagnostic.get(bufnr)
          if #diagnostics == 0 then
            return ""
          end

          local context = "LSP Diagnostics:\n"
          for _, diagnostic in ipairs(diagnostics) do
            context = context
              .. string.format(
                "• Line %d (%s): %s\n",
                diagnostic.lnum + 1,
                vim.diagnostic.severity[diagnostic.severity],
                diagnostic.message
              )
          end
          return context
        end

        -- Enhanced CodeCompanion commands with LSP context
        vim.api.nvim_buf_create_user_command(bufnr, "CCExplainError", function(opts)
          local line = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

          if #diagnostics > 0 then
            local diagnostic = diagnostics[1]
            local context = string.format("LSP Error on line %d: %s", line + 1, diagnostic.message)

            require("codecompanion").chat({
              adapter = "ollama",
              context = context,
              prompt = "Explain this error and suggest how to fix it",
            })
          else
            print("No diagnostics on current line")
          end
        end, { desc = "Explain LSP error with AI" })

        vim.api.nvim_buf_create_user_command(bufnr, "CCRefactorWithContext", function(opts)
          local start_line, end_line
          if opts.range == 2 then
            start_line, end_line = opts.line1 - 1, opts.line2 - 1
          else
            start_line, end_line = 0, vim.api.nvim_buf_line_count(bufnr) - 1
          end

          local code = table.concat(vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false), "\n")
          local diagnostics_context = get_lsp_diagnostics_context()
          local file_type = vim.bo[bufnr].filetype

          local full_context = string.format(
            [[
File type: %s
%s

Code to refactor:
```%s
%s
```]],
            file_type,
            diagnostics_context,
            file_type,
            code
          )

          require("codecompanion").chat({
            adapter = "ollama",
            context = full_context,
            prompt = "Refactor this code to fix any issues and improve quality",
          })
        end, { range = true, desc = "Refactor code with LSP context" })

        -- Keymap for quick LSP + AI integration
        local opts = { buffer = bufnr, silent = true }

        -- Explain current function/symbol
        vim.keymap.set("n", "<Leader>aF", function()
          local params = vim.lsp.util.make_position_params()
          vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result)
            if result and result.contents then
              local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
              require("codecompanion").chat({
                context = "Function information:\n" .. table.concat(hover_content, "\n"),
                prompt = "Explain this function and suggest improvements",
              })
            end
          end)
        end, vim.tbl_extend("force", opts, { desc = "Explain current function" }))

        -- Generate documentation
        vim.keymap.set("n", "<Leader>aD", function()
          local params = vim.lsp.util.make_position_params()
          vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result)
            local current_line = vim.api.nvim_get_current_line()
            local context = "Current line: " .. current_line

            if result and result.contents then
              local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
              context = context .. "\nLSP info:\n" .. table.concat(hover_content, "\n")
            end

            require("codecompanion").prompt("Generate documentation", {
              adapter = "ollama",
              strategy = "inline",
              context = context,
            })
          end)
        end, vim.tbl_extend("force", opts, { desc = "Generate documentation" }))
      end,

      -- Setup diagnostic integration for CodeCompanion
      vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = function(args)
          local bufnr = args.buf
          local diagnostics = vim.diagnostic.get(bufnr)

          -- Only for serious errors, not warnings
          local errors = vim.tbl_filter(function(d)
            return d.severity == vim.diagnostic.severity.ERROR
          end, diagnostics)

          -- if #errors > 0 and #errors <= 3 then -- Don't spam for too many errors
          --   vim.notify(string.format("Found %d errors. Use <Leader>ad to get AI suggestions", #errors))
          -- end
        end,
      }),
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "ts_ls",
            "pyright",
            "lua_ls",
            "emmet_ls",
            "html",
            "cssls",
            "jsonls",
            "tailwindcss",
            "bashls",
            "dockerls",
            "yamlls",
          },
          automatic_installation = false,
        })
      end,
    },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup({
          bind = true,
          handler_opts = {
            border = "rounded",
          },
        })
      end,
    },
    {
      "lewis6991/hover.nvim",
      config = function()
        require("hover").setup({
          init = function()
            require("hover.providers.lsp")
            require("hover.providers.gh")
            require("hover.providers.gh_user")
            require("hover.providers.jira")
            require("hover.providers.man")
            require("hover.providers.dictionary")
          end,
          preview_opts = {
            border = "rounded",
          },
          preview_window = false,
          title = true,
          mouse_providers = {
            "LSP",
          },
          mouse_delay = 1000,
        })

        vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
        vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      end,
    },
  },
}
