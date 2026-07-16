-- Vendored from sidekick.nvim by @folke (Apache-2.0).
-- https://github.com/folke/sidekick.nvim/blob/main/lua/sidekick/cli/watch.lua

local M = {}

M.watches = {} ---@type table<string, uv.uv_fs_event_t>
M.enabled = false
M.changes = {} ---@type table<string, boolean>

local function debounce(fn, ms)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local args = { ... }
    timer:start(
      ms or 20,
      0,
      vim.schedule_wrap(function()
        pcall(fn, unpack(args))
      end)
    )
  end
end

---@param buf number
local function refresh_lsp(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].modified then
    return
  end

  local uri = vim.uri_from_bufnr(buf)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    local namespace = vim.lsp.diagnostic.get_namespace(client.id)
    vim.diagnostic.reset(namespace, buf)

    if client:supports_method("textDocument/didSave", buf) then
      local params = {
        textDocument = { uri = uri },
      }
      local save = vim.tbl_get(client.server_capabilities, "textDocumentSync", "save")
      if type(save) == "table" and save.includeText then
        params.text = vim.lsp._buf_get_full_text(buf)
      end
      client:notify("textDocument/didSave", params)
    end
  end
end

function M.refresh()
  vim.cmd.checktime()
  M.changes = {}
end

---@param path string
function M.start(path)
  if M.watches[path] ~= nil then
    return
  end
  local watch = assert(vim.uv.new_fs_event())
  local ok, err = watch:start(path, {}, function(_, file)
    if file then
      M.changes[path .. "/" .. file] = true
    end
    M.refresh()
  end)
  if not ok then
    vim.notify("file-watch: failed to watch " .. path .. ": " .. tostring(err), vim.log.levels.WARN)
    return watch:is_closing() or watch:close()
  end
  M.watches[path] = watch
end

---@param buf number
---@return string?
local function dirname(buf)
  local fname = vim.api.nvim_buf_get_name(buf)
  if
    vim.api.nvim_buf_is_loaded(buf)
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].buflisted
    and fname ~= ""
    and vim.uv.fs_stat(fname) ~= nil
  then
    local path = vim.fs.dirname(fname)
    return path and path ~= "" and path or nil
  end
end

function M.update()
  local dirs = {} ---@type table<string, boolean>
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local dir = dirname(buf)
    if dir then
      dirs[dir] = true
      M.start(dir)
    end
  end
  for path in pairs(M.watches) do
    if not dirs[path] then
      M.stop(path)
    end
  end
end

M.refresh = debounce(M.refresh, 100)
M.update = debounce(M.update, 100)

---@param path string
function M.stop(path)
  local w = M.watches[path]
  if w then
    M.watches[path] = nil
    return w:is_closing() or w:close()
  end
end

function M.disable()
  if not M.enabled then
    return
  end
  M.enabled = false
  pcall(vim.api.nvim_clear_autocmds, { group = "user.file-watch" })
  pcall(vim.api.nvim_del_augroup_by_name, "user.file-watch")
  for path in pairs(M.watches) do
    M.stop(path)
  end
end

function M.enable()
  if M.enabled then
    return
  end
  M.enabled = true
  local group = vim.api.nvim_create_augroup("user.file-watch", { clear = true })

  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufWipeout", "BufReadPost" }, {
    group = group,
    callback = M.update,
  })

  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function(event)
      vim.schedule(function()
        refresh_lsp(event.buf)
      end)
    end,
  })

  M.update()
end

M.enable()

return M
