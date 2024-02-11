return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",

  dependencies = {
    "kevinhwang91/promise-async",
  },

  keys = {
    {"n", "zO", function() require("ufo").openAllFolds() end },
    {"n", "zC", function() require("ufo").closeAllFolds() end },
  },

  config = function()
    require("ufo").setup()
  end,
}

