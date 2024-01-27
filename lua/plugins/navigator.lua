-- Navigator is disabled for now as the plugin is a bit too heavy for development, we will take the features we want
return {
  "ray-x/navigator.lua",
  enabled = false,

  dependencies = {
    { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
    { "neovim/nvim-lspconfig" },
  },

  config = function()
    require("navigator").setup({
      lsp = {
        hover = {
          -- Disable navigator hover as we use noices hover effect instead
          enable = true,
        },
      },
    })
  end,
}
