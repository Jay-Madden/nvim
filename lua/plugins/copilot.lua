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
          accept = "<leader>ca",
          next = "<leader>cn",
          prev = "<leader>cp",
          dismiss = "<leader>cd",
        },
      },
      logger = {
        file_log_level = vim.log.levels.TRACE,
      },
    })
  end,
}
