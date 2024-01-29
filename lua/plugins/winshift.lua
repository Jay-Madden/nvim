return {
  "sindrets/winshift.nvim",
  keys = {
    {
      "<C-S-H>",
      function()
        require("winshift").cmd_winshift("left")
      end,
      desc = "Close debugging window",
    },
    {
      "<C-S-J>",
      function()
        require("winshift").cmd_winshift("down")
      end,
      desc = "Close debugging window",
    },
    {
      "<C-S-K>",
      function()
        require("winshift").cmd_winshift("up")
      end,
      desc = "Close debugging window",
    },
    {
      "<C-S-L>",
      function()
        require("winshift").cmd_winshift("right")
      end,
      desc = "Close debugging window",
    },
  },

  config = function()
    require("winshift").setup({
      keymaps = {
        disable_defauls = true,
      }
    })
  end
}

