return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<leader>ca",
        },
      },
    })
  end,
}
