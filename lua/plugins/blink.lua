return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  version = "v0.*",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = "super-tab" },

    completion = {
    keyword = {
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      range = 'prefix',
      -- Regex used to get the text when fuzzy matching
      regex = '[-_]\\|\\k',
      -- After matching with regex, any characters matching this regex at the prefix will be excluded
      exclude_from_prefix_regex = '[\\-]',
    },

    trigger = {
      -- When false, will not show the completion window automatically when in a snippet
      show_in_snippet = false,
      -- When true, will show the completion window after typing a character that matches the `keyword.regex`
      show_on_keyword = true,
      -- When true, will show the completion window after typing a trigger character
      show_on_trigger_character = true,
      -- LSPs can indicate when to show the completion window via trigger characters
      -- however, some LSPs (i.e. tsserver) return characters that would essentially
      -- always show the window. We block these by default.
      show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      -- When both this and show_on_trigger_character are true, will show the completion window
      -- when the cursor comes after a trigger character after accepting an item
      show_on_accept_on_trigger_character = false,
      -- When both this and show_on_trigger_character are true, will show the completion window
      -- when the cursor comes after a trigger character when entering insert mode
      show_on_insert_on_trigger_character = true,
      -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
      -- the completion window when the cursor comes after a trigger character when
      -- entering insert mode/accepting an item
      show_on_x_blocked_trigger_characters = { "'", '"', '(' },
    },

    list = {
      -- Maximum number of items to display
      max_items = 200,
      -- Controls if completion items will be selected automatically,
      -- and whether selection automatically inserts
      selection = 'preselect',
      -- Controls how the completion items are selected
      -- 'preselect' will automatically select the first item in the completion list
      -- 'manual' will not select any item by default
      -- 'auto_insert' will not select any item by default, and insert the completion items automatically
      -- when selecting them
      --
      -- You may want to bind a key to the `cancel` command, which will undo the selection
      -- when using 'auto_insert'
      cycle = {
        -- When `true`, calling `select_next` at the *bottom* of the completion list
        -- will select the *first* completion item.
        from_bottom = true,
        -- When `true`, calling `select_prev` at the *top* of the completion list
        -- will select the *last* completion item.
        from_top = true,
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
      kind_icons = {
        Text = "󰉿",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰆧",
        Class = "󰌗",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰇽",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      },
    },

    menu = {
      enabled = true,
      scrolloff = 2,
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    accept = {
      -- Create an undo point when accepting a completion item
      create_undo_point = true,
      -- Experimental auto-brackets support
      auto_brackets = {
        -- Whether to auto-insert brackets for functions
        enabled = true,
        -- Default brackets to use for unknown languages
        default_brackets = { "(", ")" },
        -- Overrides the default blocked filetypes
        override_brackets_for_filetypes = {},
        -- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { "vue" },
        },
        -- Asynchronously use semantic token to determine if brackets should be added
        semantic_token_resolution = {
          enabled = true,
          blocked_filetypes = {},
          -- How long to wait for semantic tokens to return before assuming no brackets should be added
          timeout_ms = 400,
        },
      },
    },

    ghost_text = {
      enabled = false,
    },

    -- experimental signature help support
    -- signature = { enabled = true }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
