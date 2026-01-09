return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,

  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        set_arrow_to_diag_color = true,
        show_source = {
          enabled = false,
          if_many = false,
        },
        add_messages = {
          display_count = true,
        },
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    })
    vim.diagnostic.config({ virtual_text = false })
  end,
}
