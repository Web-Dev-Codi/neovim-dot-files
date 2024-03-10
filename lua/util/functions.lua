local vim = vim
local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

local X = {}

---Join path segments that were passed as input
---@return string
function X.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

X.require_clean = require("lvim.utils.modules").require_clean
X.require_safe = require("lvim.utils.modules").require_safe
X.reload = require("lvim.utils.modules").reload

---Get the full path to `$LUNARVIM_RUNTIME_DIR`
---@return string|nil
function _G.get_runtime_dir()
  local lvim_runtime_dir = os.getenv "LUNARVIM_RUNTIME_DIR"
  if not lvim_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return lvim_runtime_dir
end

---Get the full path to `$LUNARVIM_CONFIG_DIR`
---@return string|nil
function _G.get_config_dir()
  local lvim_config_dir = os.getenv "LUNARVIM_CONFIG_DIR"
  if not lvim_config_dir then
    return vim.call("stdpath", "config")
  end
  return lvim_config_dir
end

---Get the full path to `$LUNARVIM_CACHE_DIR`
---@return string|nil
function _G.get_cache_dir()
  local lvim_cache_dir = os.getenv "LUNARVIM_CACHE_DIR"
  if not lvim_cache_dir then
    return vim.call("stdpath", "cache")
  end
  return lvim_cache_dir
end

---@param on_attach fun(client, buffer)
function X.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function X.starts_with(str, start)
  return str:sub(1, #start) == start
end

function X.is_table(to_check)
  return type(to_check) == "table"
end

function X.has_key(t, key)
  for t_key, _ in pairs(t) do
    if t_key == key then
      return true
    end
  end
  return false
end

function X.has_value(t, val)
  for _, value in ipairs(t) do
    if value == val then
      return true
    end
  end
  return false
end

function X.tprint(table)
  print(vim.inspect(table))
end

function X.tprint_keys(table)
  for k in pairs(table) do
    print(k)
  end
end

X.reload = function()
  local presentReload, reload = pcall(require, "plenary.reload")
  if presentReload then
    local counter = 0

    for moduleName in pairs(package.loaded) do
      if X.starts_with(moduleName, "lt.") then
        reload.reload_module(moduleName)
        counter = counter + 1
      end
    end
    -- clear nvim-mapper keys
    vim.g.mapper_records = nil
    vim.notify("Reloaded " .. counter .. " modules!")
  end
end

function X.is_macunix()
  return vim.fn.has "macunix"
end

function X.link_highlight(from, to, override)
  local hl_exists, _ = pcall(vim.api.nvim_get_hl_by_name, from, false)
  if override or not hl_exists then
    -- vim.cmd(("highlight link %s %s"):format(from, to))
    vim.api.nvim_set_hl(0, from, { link = to })
  end
end

X.highlight = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

X.highlight_bg = function(group, col)
  vim.api.nvim_set_hl(0, group, { bg = col })
end

-- Define fg color
-- @param group Group
-- @param color Color
X.highlight_fg = function(group, col)
  vim.api.nvim_set_hl(0, group, { fg = col })
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
X.highlight_fg_bg = function(group, fgcol, bgcol)
  vim.api.nvim_set_hl(0, group, { bg = bgcol, fg = fgcol })
end

X.from_highlight = function(hl)
  local result = {}
  local list = vim.api.nvim_get_hl_by_name(hl, true)
  for k, v in pairs(list) do
    local name = k == "background" and "bg" or "fg"
    result[name] = string.format("#%06x", v)
  end
  return result
end

X.get_color_from_terminal = function(num, default)
  local key = "terminal_color_" .. num
  return vim.g[key] and vim.g[key] or default
end

X.cmd = function(name, command, desc)
  vim.api.nvim_create_user_command(name, command, desc)
end

X.autocmd = function(evt, opts)
  vim.api.nvim_create_autocmd(evt, opts)
end
return X
