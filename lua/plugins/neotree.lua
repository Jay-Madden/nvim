local utils = require("utils")

return {
  "nvim-neo-tree/neo-tree.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  config = function()
    local neotree = require("neo-tree")
    local neotree_command = require("neo-tree.command")

    neotree.setup({
      close_if_last_window = true,
      popup_border_style = "single",
      use_popups_for_input = false,
      enable_diagnostics = true,
      enable_git_status = true,

      -- Refresh the window when files change
      use_libuv_file_watcher = true,

      window = {
        position = "left",
        mappings = {
          ["Z"] = "expand_all_nodes",
        },
        width = 30,
      },

      filesystem = {
        filtered_items = {
          visible = true,
          hide_gitignored = false,
          hide_hidden = false,
          hide_dotfiles = false,
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".DS_Store",
            ".git",
          },
        },

        follow_current_file = {
          enabled = true,
        },
      },
    })

    utils.map("n", "<leader>nt", function()
      neotree_command.execute({ toggle = true })
    end, { desc = "Toggle neotree" })
  end,
}
