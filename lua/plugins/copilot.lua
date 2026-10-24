return {
  "zbirenbaum/copilot.lua",
  enabled = not require("utils").is_container(),
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
