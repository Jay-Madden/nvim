return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  commit = "f693e2169df70b0a166ac2cc09ed6c1cb94ac897",
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
      }
    })
  end,
}
