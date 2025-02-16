return {
  "rmagatti/goto-preview",
  event = "VeryLazy",

  config = function()
    require("goto-preview").setup({
      default_mappings = true,
      border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
    })
  end,
}
