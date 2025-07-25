-- plugins.lua or lazy.nvim plugin spec
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- For completions
      "nvim-telescope/telescope.nvim", -- Optional
      "stevearc/dressing.nvim", -- Optional but recommended for better UI
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
          },
          inline = {
            adapter = "ollama",
          },
          agent = {
            adapter = "ollama",
          },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://localhost:11434",
                api_key = "dummy", -- Required but not used for local
              },
              headers = {
                ["Content-Type"] = "application/json",
              },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "llama3.2:8b",
                  choices = {
                    "llama3.2:8b",
                    "codellama:7b",
                    "codellama:13b",
                    "deepseek-coder:6.7b",
                    "phind-codellama:34b",
                  },
                },
                num_ctx = {
                  default = 16384,
                },
                temperature = {
                  default = 0.3,
                },
              },
            })
          end,
          -- Specialized adapter for code completion
          code_completion = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://localhost:11434",
                api_key = "dummy",
              },
              schema = {
                model = {
                  default = "codellama:7b", -- Faster model for completions
                },
                num_ctx = {
                  default = 4096, -- Smaller context for speed
                },
                temperature = {
                  default = 0.1, -- Lower temperature for more predictable code
                },
                top_p = {
                  default = 0.9,
                },
              },
            })
          end,
          -- Specialized adapter for code review
          code_review = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://localhost:11434",
                api_key = "dummy",
              },
              schema = {
                model = {
                  default = "llama3.2:8b", -- Better reasoning for reviews
                },
                num_ctx = {
                  default = 8192,
                },
                temperature = {
                  default = 0.2,
                },
              },
            })
          end,
        },
        prompt_library = {
          ["Code Review"] = {
            strategy = "chat",
            adapter = "code_review",
            description = "Review the selected code for bugs, improvements, and best practices",
            opts = {
              mapping = "<Leader>cr",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = [[You are an expert code reviewer. Analyze the provided code and provide:
1. Potential bugs or issues
2. Performance improvements
3. Best practices violations
4. Security concerns
5. Readability suggestions
6. Testing recommendations

Be specific and provide examples where possible.]],
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Please review this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
          ["Generate Tests"] = {
            strategy = "chat",
            adapter = "ollama",
            description = "Generate unit tests for the selected code",
            opts = {
              mapping = "<Leader>ct",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = [[You are an expert test engineer. Generate comprehensive unit tests for the provided code.
Include:
1. Happy path tests
2. Edge cases
3. Error handling tests
4. Mock setups if needed
5. Clear test descriptions

Use the appropriate testing framework for the language.]],
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Generate unit tests for this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
          ["Explain Code"] = {
            strategy = "chat",
            adapter = "ollama",
            description = "Explain how the selected code works",
            opts = {
              mapping = "<Leader>ce",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are an expert programmer. Explain code clearly and concisely, including the purpose, how it works, and any important details.",
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Please explain this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
          ["Fix Code"] = {
            strategy = "inline",
            adapter = "code_completion",
            description = "Fix issues in the selected code",
            opts = {
              mapping = "<Leader>cf",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are an expert programmer. Fix any bugs, syntax errors, or logical issues in the provided code. Return only the corrected code without explanations.",
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Fix this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
          ["Optimize Code"] = {
            strategy = "inline",
            adapter = "ollama",
            description = "Optimize the selected code for performance",
            opts = {
              mapping = "<Leader>co",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are an expert programmer. Optimize the provided code for better performance while maintaining the same functionality. Return only the optimized code.",
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Optimize this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
          ["Add Comments"] = {
            strategy = "inline",
            adapter = "code_completion",
            description = "Add helpful comments to the selected code",
            opts = {
              mapping = "<Leader>cc",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "Add helpful, concise comments to the provided code to explain what it does. Keep the original code intact and only add comments.",
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Add comments to this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
          },
          chat = {
            window = {
              layout = "vertical", -- vertical|horizontal|buffer
              width = 0.45,
              height = 0.4,
              relative = "editor",
              opts = {
                breakindent = true,
                cursorcolumn = false,
                cursorline = false,
                foldcolumn = "0",
                linebreak = true,
                list = false,
                signcolumn = "no",
                spell = false,
                wrap = true,
              },
            },
          },
        },
        opts = {
          log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
          send_code = true, -- Send code context with requests
          use_default_actions = true, -- Use default actions
          use_default_prompt_library = false, -- We're defining our own
        },
        -- Integration with LSP and diagnostics
        on_attach = function(bufnr)
          -- Get LSP diagnostics for context
          local function get_diagnostics()
            local diagnostics = vim.diagnostic.get(bufnr)
            if #diagnostics > 0 then
              local diagnostic_text = "Current diagnostics:\n"
              for _, diagnostic in ipairs(diagnostics) do
                diagnostic_text = diagnostic_text
                  .. string.format("Line %d: %s\n", diagnostic.lnum + 1, diagnostic.message)
              end
              return diagnostic_text
            end
            return ""
          end

          -- Custom command to fix LSP diagnostics
          vim.api.nvim_buf_create_user_command(bufnr, "CodeCompanionFixDiagnostics", function()
            local diagnostics = get_diagnostics()
            if diagnostics ~= "" then
              require("codecompanion").prompt("fix_diagnostics", {
                context = diagnostics,
                selection = true,
              })
            else
              print("No diagnostics found")
            end
          end, { range = true })
        end,
      })
    end,
    -- Lazy loading
    event = "VeryLazy",
    -- Alternative: load on specific commands
    -- cmd = { "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionToggle" },
  },

  -- Optional: Enhanced completion with nvim-cmp integration
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      -- Add codecompanion as a completion source
      table.insert(opts.sources, {
        name = "codecompanion",
        group_index = 1,
        priority = 100,
      })
    end,
  },
}
