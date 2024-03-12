return {
  "neoclide/coc.nvim",
  requires = {
    "rafcamlet/coc-nvim-lua",
    "clangd/coc-clangd",
    "josa42/coc-go",
    "iamcco/coc-spell-checker",
  },
  branch = "release",
  run = "npm clean-install",
  config = function()
    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    vim.opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    vim.opt.signcolumn = "yes"

    local keyset = vim.keymap.set
    -- key bind
    --
    -- Autocomplete
    function _G.check_back_space()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
    end
    vim.o.hidden = true
    vim.api.nvim_set_keymap("x", "<leader>f", "<Plug>(coc-format-selected)", { noremap = false })
    local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
    vim.keymap.set("i", "`", function()
      return vim.fn["coc#pum#next"](1)
    end, opts)
    vim.keymap.set("i", "<Tab>", function()
      if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#next"](1)
      end
      if require("plugin.coc").check_back_space() then
        return vim.fn["coc#refresh"]()
      end
      return "<Tab>"
    end, { noremap = true, expr = true })
    vim.keymap.set("i", "<S-Tab>", function()
      if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#prev"](1)
      end
      return "<S-Tab>"
    end, opts)

    vim.keymap.set("i", "<CR>", function()
      if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#confirm"]()
      end
      return "\r"
    end, opts)
    -- Use K to show documentation in preview window
    function _G.show_docs()
      local cw = vim.fn.expand "<cword>"
      if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command("h " .. cw)
      elseif vim.api.nvim_eval "coc#rpc#ready()" then
        vim.fn.CocActionAsync "doHover"
      else
        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
      end
    end

    keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "Highlight symbol under cursor on CursorHold",
    })

    -- Symbol renaming
    keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

    -- Formatting selected code
    -- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
    -- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

    -- Setup formatexpr specified filetype(s)
    vim.api.nvim_create_autocmd("FileType", {
      group = "CocGroup",
      pattern = "typescript,json",
      command = "setl formatexpr=CocAction('formatSelected')",
      desc = "Setup formatexpr specified filetype(s).",
    })

    -- Update signature help on jump placeholder
    vim.api.nvim_create_autocmd("User", {
      group = "CocGroup",
      pattern = "CocJumpPlaceholder",
      command = "call CocActionAsync('showSignatureHelp')",
      desc = "Update signature help on jump placeholder",
    })

    -- Apply codeAction to the selected region
    -- Example: `<leader>aap` for current paragraph
    local opts = { silent = true, nowait = true }
    keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
    keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

    -- Remap keys for apply code actions at the cursor position.
    keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
    -- Remap keys for apply source code actions for current file.
    keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
    -- Apply the most preferred quickfix action on the current line.
    keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

    -- Remap keys for apply refactor code actions.
    keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
    keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
    --[[  keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true }) ]]

    -- Run the Code Lens actions on the current line
    keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

    -- Map function and class text objects
    -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
    keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
    keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
    keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
    keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
    keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
    keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
    keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
    keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

    -- Use CTRL-S for selections ranges
    -- Requires 'textDocument/selectionRange' support of language server
    keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
    keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

    -- Add `:Format` command to format current buffer
    vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

    -- " Add `:Fold` command to fold current buffer
    vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

    -- Add `:OR` command for organize imports of the current buffer
    vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

    -- Add (Neo)Vim's native statusline support
    -- NOTE: Please see `:h coc-status` for integrations with external plugins that
    -- provide custom statusline: lightline.vim, vim-airline
    vim.opt.statusline:prepend "%{coc#status()}%{get(b:,'coc_current_function','')}"

    -- Mappings for CoCList
    -- code actions and coc stuff
    ---@diagnostic disable-next-line: redefined-local
    local opts = { silent = true, nowait = true }
    -- Show all diagnostics
    -- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
    -- Manage extensions
    keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
    -- Show commands
    -- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
    -- Find symbol of current document
    keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
    -- Search workspace symbols
    keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
    -- Do default action for next item
    keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
    -- Do default action for previous item
    keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
    -- Resume latest coc list
    --[[   keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts) ]]
  end,
  opt = true,
  event = "BufEnter",
}
