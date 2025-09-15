return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  enabled = false,
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = false,
        auto_refresh = true,
        keymap = {
          accept = "<leader>ca",
          next = "<leader>cn",
          prev = "<leader>cp",
          dismiss = "<leader>cd",
        },
      },
    })
  end,
}
