return {
  "shellRaining/hlchunk.nvim",

  event = { "BufReadPre", "BufNewFile" },

  config = function()
    require("hlchunk").setup({
      chunk = {
          enable = true,
          duration = 50,
          delay = 50,
      },
    })
  end
}

