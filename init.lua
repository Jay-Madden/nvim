-- Initialize initial configuration 
require("config.options")

-- Initialize keymappings
require("config.keymaps")

-- Initialize lazy.nvim
require("config.lazy")


require("onedark").setup({
 style = "cool",
})
require("onedark").load()
