return {
  "lewis6991/gitsigns.nvim",
  -- We have to load it actively or else it will only load on keybinding invoke
  event = "VeryLazy",

  keys = {
    { "<Leader>qr", "<CMD>Gitsigns reset_hunk<CR>", desc = "Reset git change at cursor position" },
    {
      "<Leader>qt",
      "<CMD>Gitsigns preview_hunk<CR>",
      desc = "Reset git change at cursor position",
    },
  },

  config = function()
    require("gitsigns").setup({
      signcolumn = true,
      signs_staged_enable = true,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },

      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      preview_config = {
        border = "rounded",
      },
    })
  end,
}
