return {
  "folke/trouble.nvim",
  keys = {
    {
      "<leader>es",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>eS",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>eq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List (Trouble)",
    },
  },

  config = function()
    require("trouble").setup({})
  end,
}
