return {
  "akinsho/toggleterm.nvim",

  keys = {
    { "<Leader>t", function() TOGGLE_HORIZONTAL_TERMINAL() end, desc = "Open floating terminal" },
  },

  config = function()
    require("toggleterm").setup()

    local Terminal = require("toggleterm.terminal").Terminal

    local terminal_horizontal
    ---@diagnostic disable-next-line: missing-global-doc
    function TOGGLE_HORIZONTAL_TERMINAL()
      if terminal_horizontal == nil then
        terminal_horizontal = Terminal:new({
          direction = "horizontal",
          hidden = true,
          on_exit = function() terminal_horizontal = nil end,
        })
      end
      terminal_horizontal:toggle()
    end
  end,
}
