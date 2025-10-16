return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  enabled = true,
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = false,
        auto_refresh = true,
        keymap = {
          accept = "<leader>ia",
          next = "<leader>in",
          prev = "<leader>ip",
          dismiss = "<leader>id",
        },
      },
    })
  end,
}
