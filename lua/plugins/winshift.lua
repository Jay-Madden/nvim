return {
  "sindrets/winshift.nvim",
  enabled = false,
  keys = {
    {
      "<C-S-H>",
      function()
        require("winshift").cmd_winshift("left")
      end,
      desc = "Move window left",
    },
    {
      "<C-S-J>",
      function()
        require("winshift").cmd_winshift("down")
      end,
      desc = "Move window down",
    },
    {
      "<C-S-K>",
      function()
        require("winshift").cmd_winshift("up")
      end,
      desc = "Move window up",
    },
    {
      "<C-S-L>",
      function()
        require("winshift").cmd_winshift("right")
      end,
      desc = "Move window right",
    },
  },

  config = function()
    require("winshift").setup({
      keymaps = {
        disable_defauls = true,
      },
    })
  end,
}
