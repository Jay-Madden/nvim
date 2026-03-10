-- Setup snacks.nvim debugging helpers
-- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
if vim.fn.has("nvim-0.11") == 1 then
  vim._print = function(_, ...)
    dd(...)
  end
else
  vim.print = dd
end-----------------------------------

-- Initialize initial configuration
require("config.options")

-- Initialize keymappings
require("config.keymaps")

-- Initialize lazy.nvim
require("config.lazy")
