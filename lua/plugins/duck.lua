return {
  "tamton-aquib/duck.nvim",
  keys = {
    {
      "<leader>dd",
      function()
        require("duck").hatch()
      end,
      desc = "Spawn a duck on screen",
    },
    {
      "<leader>dk",
      function()
        require("duck").cook()
      end,
      desc = "Remove one duck",
    },
    {
      "<leader>da",
      function()
        require("duck").cook_all()
      end,
      desc = "Remove all ducks",
    },
  },
}
