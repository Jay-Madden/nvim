local modules = { 
  require("plugins.snacks.features"),
  require("plugins.snacks.picker"),
  require("plugins.snacks.dashboard") 
}

-- Collect all keys from feature files
local all_keys = {}

for _, mod in ipairs(modules) do
  vim.list_extend(all_keys, mod.keys or {})
end

local all_opts = {}
for _, mod in ipairs(modules) do
  all_opts = vim.tbl_deep_extend("error", all_opts, mod.opts)
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = all_keys,
  ---@type snacks.Config
  opts = all_opts,
}
