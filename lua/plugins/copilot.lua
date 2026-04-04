return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = false,
        auto_refresh = true,
        keymap = {
          accept = "<leader>ca",
          next = "<leader>cn",
          prev = "<leader>ccp",
          dismiss = "<leader>ccd",
        },
      },
    })
  end,
}
