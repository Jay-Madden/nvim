return {
  "petertriho/nvim-scrollbar",
  --
  -- Neovide works weirdly with scrollbar support
  enabled = function()
    return not vim.g.neovide
  end,

  config = function()
    require("scrollbar").setup()
  end,
}
