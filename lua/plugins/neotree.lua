return {
	"nvim-neo-tree/neo-tree.nvim",
	event = "VeryLazy",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},

  opts = {
    close_if_last_window = true,
    popup_border_style = "single",
    use_popups_for_input = false,

    window = {
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
			},

			follow_current_file = {
				enabled = true
			},
		},
	},
}

