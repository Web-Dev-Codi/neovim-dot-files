local lush = require("lush")
local hsl = lush.hsl

-- Star Wars Lightsaber Colors
local blue_saber = hsl("#0081FF")
local green_saber = hsl("#60FF60")
local red_saber = hsl("#FF1919")
local purple_saber = hsl("#912CEE")

---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
  return {
    -- Base
    Normal({ fg = blue_saber, bg = "NONE", gui = "bold" }), -- Normal text
    NormalFloat({ fg = blue_saber, bg = "NONE" }), -- Normal text in floating windows
    Comment({ fg = green_saber.da(40), gui = "bold,italic" }), -- Comments

    -- Keywords and Programming
    Keyword({ fg = red_saber, gui = "bold,italic" }),
    Statement({ fg = red_saber, gui = "bold,italic" }),
    Conditional({ fg = red_saber, gui = "bold,italic" }),
    Repeat({ fg = red_saber, gui = "bold,italic" }),
    Label({ fg = red_saber, gui = "bold,italic" }),
    Operator({ fg = purple_saber, gui = "bold" }),

    -- Functions and Variables
    Function({ fg = blue_saber, gui = "bold" }),
    Identifier({ fg = green_saber, gui = "bold" }),
    Variable({ fg = blue_saber.li(20), gui = "bold" }),

    -- Constants and Values
    Constant({ fg = purple_saber, gui = "bold" }),
    String({ fg = green_saber, gui = "bold" }),
    Number({ fg = purple_saber.li(20), gui = "bold" }),
    Boolean({ fg = red_saber, gui = "bold" }),

    -- Special
    Special({ fg = purple_saber.li(10), gui = "bold" }),
    SpecialChar({ fg = purple_saber.li(20), gui = "bold" }),
    Type({ fg = blue_saber.li(10), gui = "bold,italic" }),

    -- UI Elements
    LineNr({ fg = blue_saber.da(40), gui = "bold" }),
    CursorLine({ bg = blue_saber.da(80).sa(20) }),
    CursorLineNr({ fg = blue_saber, gui = "bold" }),
    SignColumn({ bg = "NONE" }),

    -- Messages and Diagnostics
    Error({ fg = red_saber, gui = "bold" }),
    Warning({ fg = purple_saber, gui = "bold" }),
    Info({ fg = blue_saber, gui = "bold" }),
    Hint({ fg = green_saber, gui = "bold" }),

    -- Search and Selection
    Search({ fg = "black", bg = green_saber }),
    IncSearch({ fg = "black", bg = blue_saber }),
    Visual({ bg = blue_saber.da(60) }),

    -- Pmenu
    Pmenu({ fg = blue_saber, bg = "NONE" }),
    PmenuSel({ fg = "black", bg = blue_saber }),
    PmenuSbar({ bg = blue_saber.da(50) }),
    PmenuThumb({ bg = blue_saber }),
  }
end)

return theme
