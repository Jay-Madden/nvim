return {
  "Jay-Madden/auto-fix-return.nvim",
  event = "VeryLazy",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    require("auto-fix-return").setup({
      enabled = true,
    })
  end,
}
