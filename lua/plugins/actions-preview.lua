return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",

  config = function()
    require("actions-preview").setup({
      backend = {"snacks"},

      snacks = {
        layout = { preset = "dropdown" },
      },
    })
    vim.keymap.set("n", "<leader>hh", require("actions-preview").code_actions)
  end,
}
