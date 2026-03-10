return {
  "echasnovski/mini.nvim",
  event = "BufReadPost",

  config = function()
    require("mini.surround").setup()
    require("mini.ai").setup()
  end,
}
