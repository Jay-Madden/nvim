return {
  "akinsho/bufferline.nvim",
  enabled = false,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("bufferline").setup({
      options = {
        --separator_style = "slant",
        diagnostics = "nvim_lsp",
      },
    })
  end,
}
