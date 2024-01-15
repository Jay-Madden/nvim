return {
	"nvim-neo-tree/neo-tree.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		-- If you want icons for diagnostic errors, you'll need to define them somewhere:
		vim.fn.sign_define("DiagnosticSignError",
			{text = " ", texthl = "DiagnosticSignError"})
		vim.fn.sign_define("DiagnosticSignWarn",
			{text = " ", texthl = "DiagnosticSignWarn"})
		vim.fn.sign_define("DiagnosticSignInfo",
			{text = " ", texthl = "DiagnosticSignInfo"})
		vim.fn.sign_define("DiagnosticSignHint",
			{text = "󰌵", texthl = "DiagnosticSignHint"})

		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "single",
			use_popups_for_input = false,
			enable_diagnostics = true,
			enable_git_status = true,

			-- Refresh the window when files change
			use_libuv_file_watcher=true,

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
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						".DS_Store",
					},
				},

				follow_current_file = {
					enabled = true
				},
			},
		})
	end,
}

