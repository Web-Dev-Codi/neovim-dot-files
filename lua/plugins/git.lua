return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = true,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
      vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>")
      vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
      vim.keymap.set("n", "<leader>gl", ":Git pull<CR>")
      vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
      vim.keymap.set("n", "<leader>ga", ":Git add .<CR>")
      vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
      vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
      vim.keymap.set("n", "<leader>gh", ":0Gclog<CR>")
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" },
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new buffer" },
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" },
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" },
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" },
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel." },
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle through available layouts." },
            },
            {
              "n",
              "[x",
              require("diffview.actions").prev_conflict,
              { desc = "In the merge-tool: jump to the previous conflict" },
            },
            {
              "n",
              "]x",
              require("diffview.actions").next_conflict,
              { desc = "In the merge-tool: jump to the next conflict" },
            },
            {
              "n",
              "<leader>co",
              require("diffview.actions").conflict_choose("ours"),
              { desc = "Choose the OURS version of a conflict" },
            },
            {
              "n",
              "<leader>ct",
              require("diffview.actions").conflict_choose("theirs"),
              { desc = "Choose the THEIRS version of a conflict" },
            },
            {
              "n",
              "<leader>cb",
              require("diffview.actions").conflict_choose("base"),
              { desc = "Choose the BASE version of a conflict" },
            },
            {
              "n",
              "<leader>ca",
              require("diffview.actions").conflict_choose("all"),
              { desc = "Choose all the versions of a conflict" },
            },
            {
              "n",
              "dx",
              require("diffview.actions").conflict_choose("none"),
              { desc = "Delete the conflict region" },
            },
          },
          diff1 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            {
              "n",
              "g?",
              require("diffview.actions").help({ "view", "diff3" }),
              { desc = "Open the help panel" },
            },
          },
          diff4 = {
            {
              "n",
              "g?",
              require("diffview.actions").help({ "view", "diff4" }),
              { desc = "Open the help panel" },
            },
          },
          file_panel = {
            {
              "n",
              "j",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "<down>",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "k",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<up>",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<cr>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "o",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "<2-LeftMouse>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "-",
              require("diffview.actions").toggle_stage_entry,
              { desc = "Stage / unstage the selected entry." },
            },
            {
              "n",
              "S",
              require("diffview.actions").stage_all,
              { desc = "Stage all entries." },
            },
            {
              "n",
              "U",
              require("diffview.actions").unstage_all,
              { desc = "Unstage all entries." },
            },
            {
              "n",
              "X",
              require("diffview.actions").restore_entry,
              { desc = "Restore entry to the state on the left side." },
            },
            {
              "n",
              "L",
              require("diffview.actions").open_commit_log,
              { desc = "Open the commit log panel." },
            },
            {
              "n",
              "zo",
              require("diffview.actions").open_fold,
              { desc = "Expand fold" },
            },
            {
              "n",
              "h",
              require("diffview.actions").close_fold,
              { desc = "Collapse fold" },
            },
            {
              "n",
              "zc",
              require("diffview.actions").close_fold,
              { desc = "Collapse fold" },
            },
            {
              "n",
              "za",
              require("diffview.actions").toggle_fold,
              { desc = "Toggle fold" },
            },
            {
              "n",
              "zR",
              require("diffview.actions").open_all_folds,
              { desc = "Expand all folds" },
            },
            {
              "n",
              "zM",
              require("diffview.actions").close_all_folds,
              { desc = "Collapse all folds" },
            },
            {
              "n",
              "<c-b>",
              require("diffview.actions").scroll_view(-0.25),
              { desc = "Scroll the view up" },
            },
            {
              "n",
              "<c-f>",
              require("diffview.actions").scroll_view(0.25),
              { desc = "Scroll the view down" },
            },
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" },
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new buffer" },
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" },
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" },
            },
            {
              "n",
              "i",
              require("diffview.actions").listing_style,
              { desc = "Toggle between 'list' and 'tree' views" },
            },
            {
              "n",
              "f",
              require("diffview.actions").toggle_flatten_dirs,
              { desc = "Flatten empty subdirectories in tree listing style." },
            },
            {
              "n",
              "R",
              require("diffview.actions").refresh_files,
              { desc = "Update stats and entries in the file list." },
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" },
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel" },
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle available layouts" },
            },
            {
              "n",
              "[x",
              require("diffview.actions").prev_conflict,
              { desc = "Go to the previous conflict" },
            },
            {
              "n",
              "]x",
              require("diffview.actions").next_conflict,
              { desc = "Go to the next conflict" },
            },
            {
              "n",
              "g?",
              require("diffview.actions").help("file_panel"),
              { desc = "Open the help panel" },
            },
          },
          file_history_panel = {
            {
              "n",
              "g!",
              require("diffview.actions").options,
              { desc = "Open the option panel" },
            },
            {
              "n",
              "<C-A-d>",
              require("diffview.actions").open_in_diffview,
              { desc = "Open the entry under the cursor in a diffview" },
            },
            {
              "n",
              "y",
              require("diffview.actions").copy_hash,
              { desc = "Copy the commit hash of the entry under the cursor" },
            },
            {
              "n",
              "L",
              require("diffview.actions").open_commit_log,
              { desc = "Show commit details" },
            },
            {
              "n",
              "zR",
              require("diffview.actions").open_all_folds,
              { desc = "Expand all folds" },
            },
            {
              "n",
              "zM",
              require("diffview.actions").close_all_folds,
              { desc = "Collapse all folds" },
            },
            {
              "n",
              "j",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "<down>",
              require("diffview.actions").next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "k",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<up>",
              require("diffview.actions").prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<cr>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "o",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "<2-LeftMouse>",
              require("diffview.actions").select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "<c-b>",
              require("diffview.actions").scroll_view(-0.25),
              { desc = "Scroll the view up" },
            },
            {
              "n",
              "<c-f>",
              require("diffview.actions").scroll_view(0.25),
              { desc = "Scroll the view down" },
            },
            {
              "n",
              "<tab>",
              require("diffview.actions").select_next_entry,
              { desc = "Open the diff for the next file" },
            },
            {
              "n",
              "<s-tab>",
              require("diffview.actions").select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
            {
              "n",
              "gf",
              require("diffview.actions").goto_file,
              { desc = "Open the file in a new buffer" },
            },
            {
              "n",
              "<C-w><C-f>",
              require("diffview.actions").goto_file_split,
              { desc = "Open the file in a new split" },
            },
            {
              "n",
              "<C-w>gf",
              require("diffview.actions").goto_file_tab,
              { desc = "Open the file in a new tabpage" },
            },
            {
              "n",
              "<leader>e",
              require("diffview.actions").focus_files,
              { desc = "Bring focus to the file panel" },
            },
            {
              "n",
              "<leader>b",
              require("diffview.actions").toggle_files,
              { desc = "Toggle the file panel" },
            },
            {
              "n",
              "g<C-x>",
              require("diffview.actions").cycle_layout,
              { desc = "Cycle available layouts" },
            },
            {
              "n",
              "g?",
              require("diffview.actions").help("file_history_panel"),
              { desc = "Open the help panel" },
            },
          },
          option_panel = {
            {
              "n",
              "<tab>",
              require("diffview.actions").select_entry,
              { desc = "Change the current option" },
            },
            {
              "n",
              "q",
              require("diffview.actions").close,
              { desc = "Close the panel" },
            },
            {
              "n",
              "g?",
              require("diffview.actions").help("option_panel"),
              { desc = "Open the help panel" },
            },
          },
          help_panel = {
            {
              "n",
              "q",
              require("diffview.actions").close,
              { desc = "Close help menu" },
            },
            {
              "n",
              "<esc>",
              require("diffview.actions").close,
              { desc = "Close help menu" },
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>")
      vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>")
      vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>")
      vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory %<CR>")
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    config = function()
      require("neogit").setup({
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        disable_builtin_editor = false,
        disable_insert_on_commit = "auto",
        use_magit_keybindings = false,
        auto_refresh = true,
        auto_show_console = true,
        remember_settings = true,
        use_per_project_settings = true,
        ignored_settings = {},
        highlight = {
          italic = true,
          bold = true,
          underline = true,
        },
        use_default_keymaps = true,
        commit_popup = {
          kind = "split",
        },
        popup = {
          kind = "split",
        },
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = {
          telescope = true,
          diffview = true,
        },
        sections = {
          sequencer = {
            folded = false,
            hidden = false,
          },
          untracked = {
            folded = false,
            hidden = false,
          },
          unstaged = {
            folded = false,
            hidden = false,
          },
          staged = {
            folded = false,
            hidden = false,
          },
          stashes = {
            folded = true,
            hidden = false,
          },
          unpulled_upstream = {
            folded = true,
            hidden = false,
          },
          unmerged_upstream = {
            folded = false,
            hidden = false,
          },
          unpulled_pushRemote = {
            folded = true,
            hidden = false,
          },
          unmerged_pushRemote = {
            folded = false,
            hidden = false,
          },
          recent = {
            folded = true,
            hidden = false,
          },
          rebase = {
            folded = true,
            hidden = false,
          },
        },
        mappings = {
          commit_editor = {
            ["q"] = "Close",
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
          },
          rebase_editor = {
            ["p"] = "Pick",
            ["r"] = "Reword",
            ["e"] = "Edit",
            ["s"] = "Squash",
            ["f"] = "Fixup",
            ["x"] = "Execute",
            ["d"] = "Drop",
            ["b"] = "Break",
            ["q"] = "Close",
            ["<cr>"] = "OpenCommit",
            ["gk"] = "MoveUp",
            ["gj"] = "MoveDown",
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
            ["[c"] = "OpenOrScrollUp",
            ["]c"] = "OpenOrScrollDown",
          },
          finder = {
            ["<cr>"] = "Select",
            ["<c-c>"] = "Close",
            ["<esc>"] = "Close",
            ["<c-n>"] = "Next",
            ["<c-p>"] = "Previous",
            ["<down>"] = "Next",
            ["<up>"] = "Previous",
            ["<tab>"] = "MultiselectToggleNext",
            ["<s-tab>"] = "MultiselectTogglePrevious",
            ["<c-j>"] = "NOP",
          },
          popup = {
            ["?"] = "HelpPopup",
            ["A"] = "CherryPickPopup",
            ["D"] = "DiffPopup",
            ["M"] = "RemotePopup",
            ["P"] = "PushPopup",
            ["X"] = "ResetPopup",
            ["Z"] = "StashPopup",
            ["b"] = "BranchPopup",
            ["c"] = "CommitPopup",
            ["f"] = "FetchPopup",
            ["l"] = "LogPopup",
            ["m"] = "MergePopup",
            ["p"] = "PullPopup",
            ["r"] = "RebasePopup",
            ["v"] = "RevertPopup",
          },
          status = {
            ["q"] = "Close",
            ["I"] = "InitRepo",
            ["1"] = "Depth1",
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
            ["<tab>"] = "Toggle",
            ["x"] = "Discard",
            ["s"] = "Stage",
            ["S"] = "StageUnstaged",
            ["<c-s>"] = "StageAll",
            ["u"] = "Unstage",
            ["U"] = "UnstageStaged",
            ["$"] = "CommandHistory",
            ["Y"] = "YankSelected",
            ["<c-r>"] = "RefreshBuffer",
            ["<enter>"] = "GoToFile",
            ["<c-v>"] = "VSplitOpen",
            ["<c-x>"] = "SplitOpen",
            ["<c-t>"] = "TabOpen",
            ["{"] = "GoToPreviousHunkHeader",
            ["}"] = "GoToNextHunkHeader",
          },
        },
      })

      vim.keymap.set("n", "<leader>gg", require("neogit").open, { silent = true, desc = "Open Neogit" })
    end,
  },
}
