return {
  "akinsho/git-conflict.nvim",
  event = "VeryLazy",

  config = function()
    require("git-conflict").setup({})
    -- HACK: taken from here: https://github.com/akinsho/git-conflict.nvim/pull/20#issue-1259829668
    -- vim.api.nvim_set_hl(0, 'DiffText', { fg = "#ffffff", bg = "#1d3b40" })
    -- vim.api.nvim_set_hl(0, 'DiffAdd', { fg = "#ffffff", bg = "#1d3450" })
  end,
}
