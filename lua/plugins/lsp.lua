return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "williamboman/mason-lspconfig.nvim", config = function() end },
  },
  opts = function()
    -- CodeCompanion LSP Integration Functions
    local function enhanced_on_attach(client, bufnr)
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
    end

    ---@class PluginLspOpts
    local ret = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        tsserver = {
          enabled = false,
        },
        emmet_language_server = {
          enabled = true,
          filetypes = {
            "css",
            "html",
            "json",
            "jsonc",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
          },
        },
        ts_ls = {
          enabled = false,
        },
        html = {
          enabled = true,
          filetypes = { "html" },
        },
        cssls = {
          enabled = true,
          filetypes = { "css", "scss", "less" },
        },
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
        jsonls = {
          settings = {
            completion = true,
            comments = {
              enable = true,
            },
          },
          filetypes = { "json", "jsonc" },
        },
        rust_analyzer = {
          enabled = true,
        },
        yamlls = {},
        biome = {
          enabled = true,
        },
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
        -- emmet_ls = {},
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          -- ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = false,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- Add enhanced on_attach for CodeCompanion integration
        ["*"] = function(server, opts)
          if opts.on_attach then
            local original_on_attach = opts.on_attach
            opts.on_attach = function(client, bufnr)
              original_on_attach(client, bufnr)
              enhanced_on_attach(client, bufnr)
            end
          else
            opts.on_attach = enhanced_on_attach
          end
        end,
        tailwindcss = function(_, opts)
          local tw = LazyVim.lsp.get_raw_config("tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Additional settings for Phoenix projects
          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    }
    -- Setup diagnostic integration for CodeCompanion
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function(args)
        local bufnr = args.buf
        local diagnostics = vim.diagnostic.get(bufnr)

        -- Only for serious errors, not warnings
        local errors = vim.tbl_filter(function(d)
          return d.severity == vim.diagnostic.severity.ERROR
        end, diagnostics)

        if #errors > 0 and #errors <= 3 then -- Don't spam for too many errors
          vim.notify(string.format("Found %d errors. Use <Leader>ad to get AI suggestions", #errors))
        end
      end,
    })

    return ret
  end,
}
