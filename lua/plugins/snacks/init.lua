local features = require("plugins.snacks.features")
local picker = require("plugins.snacks.picker")
local dashboard = require("plugins.snacks.dashboard")

-- Collect all keys from feature files
local all_keys = {}
vim.list_extend(all_keys, features.keys or {})
vim.list_extend(all_keys, picker.keys or {})

-- Collect all opts from feature files
local all_opts = {}
vim.tbl_deep_extend("force", all_opts, features.opts)
all_opts.picker = picker.opts
all_opts.dashboard = dashboard.opts

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = all_keys,
  ---@type snacks.Config
  opts = all_opts,
}
