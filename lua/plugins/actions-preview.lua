return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",

  config = function()
    vim.keymap.set("n", "<leader>hh", require("actions-preview").code_actions)
  end,
}
