return {
  "chentoast/marks.nvim",
  event = "BufReadPost",

  config = function()
    require("marks").setup({})
  end,
}
