-- plugins.lua or lazy.nvim plugin spec
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>a" },
      { "<leader>aa" },
      { "<leader>ac" },
      { "<leader>ai" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- For completions
      "nvim-telescope/telescope.nvim", -- Optional
      "stevearc/dressing.nvim", -- Optional but recommended for better UI
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            show_repository = false,
          },
        },
      })

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls" }, -- Ensure Lua language server is installed
      })

      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
            tools = {
              groups = {
                "search_nvim_docs",
                "get_nvim_help",
                "validate_nvim_config",
                "generate_nvim_config",
                "explain_nvim_concept",
              },
            },
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
                  default = "qwen2.5-coder:7b",
                  choices = {
                    "codegemma:7b",
                    "codellama:7b",
                    "codellama:13b",
                    "codellama:34b",
                    "deepcoder:14b",
                    "deepseek-coder:6.7b",
                    "deepseek-r1:32b",
                    "fastcode:latest",
                    "llama3.1:8b",
                    "llama3.2:3b",
                    "phind-codellama:latest",
                    "qwen2.5-coder:7b",
                    "dolphin3:8b",
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

          extensions = {
            mcphub = {
              callback = "mcphub.extensions.codecompanion",
              opts = {
                -- MCP Tools
                make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
                show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
                add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
                show_result_in_chat = true, -- Show tool results directly in chat buffer
                format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
                -- MCP Resources
                make_vars = true, -- Convert MCP resources to #variables for prompts
                -- MCP Prompts
                make_slash_commands = true, -- Add MCP prompts as /slash commands
              },
            },
          },
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
                  default = "llama3.1:8b", -- Better reasoning for reviews
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
          ["Generate Documentation"] = {
            strategy = "chat",
            adapter = "ollama",
            description = "Generate documentation for the selected code",
            opts = {
              mapping = "<Leader>cd",
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = [[You are an expert technical writer specializing in code documentation. Create comprehensive and clear documentation for the provided code that follows these guidelines:
1. Begin with a brief overview of what the code does
2. Document function parameters, return values, and types
3. Explain key algorithms or logic flows
4. Note any side effects or important behaviors
5. Include usage examples where appropriate
6. Document any dependencies or requirements
7. Follow language-specific documentation standards (JSDoc, docstrings, etc.)

Adapt your documentation style to match the language and context of the code.]],
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Generate documentation for this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
              },
            },
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            -- Fix UI shifting issues
            border = "rounded",
            relative = "editor",
            row = "50%",
            col = "50%",
            anchor = "NW",
            style = "minimal",
            focusable = true,
            zindex = 1000,
            -- Additional UI stability settings
            noautocmd = true,
            title = "Select Model",
            title_pos = "center",
          },
          -- Add selection menu specific configuration
          selection = {
            -- Prevent UI shifting during navigation
            stable_positioning = true,
            preserve_cursor = true,
            redraw_on_change = false,
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
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              -- MCP Tools
              make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true, -- Show tool results directly in chat buffer
              format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true, -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true, -- Add MCP prompts as /slash commands
            },
          },
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
    event = "VeryLazy",
    opts = function(_, opts)
      -- Ensure opts.sources exists
      opts.sources = opts.sources or {}
      -- Add codecompanion as a completion source
      table.insert(opts.sources, {
        name = "codecompanion",
        group_index = 1,
        priority = 100,
      })
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup({
        --- `mcp-hub` binary related options-------------------
        config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
        port = 37373, -- The port `mcp-hub` server listens to
        shutdown_delay = 5 * 60 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 5 minutes)
        use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
        mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks
        global_env = {}, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
        workspace = {
          enabled = true, -- Enable project-local configuration files
          look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
          reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
          port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
          get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
        },

        ---Chat-plugin related options-----------------
        auto_approve = false, -- Auto approve mcp tool calls
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
        extensions = {
          codecompanion = {
            make_slash_commands = true, -- make /slash commands from CodeCompanion prompts
          },
        },

        --- Plugin specific options-------------------
        native_servers = {}, -- add your custom lua native servers here
        builtin_tools = {
          edit_file = {
            parser = {
              track_issues = true,
              extract_inline_content = true,
            },
            locator = {
              fuzzy_threshold = 0.8,
              enable_fuzzy_matching = true,
            },
            ui = {
              go_to_origin_on_complete = true,
              keybindings = {
                accept = ".",
                reject = ",",
                next = "n",
                prev = "p",
                accept_all = "ga",
                reject_all = "gr",
              },
            },
          },
        },
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
            relative = "editor",
            zindex = 50,
            border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
          },
          wo = { -- window-scoped options (vim.wo)
            winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
          },
        },
        json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
}
