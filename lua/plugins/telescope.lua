return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},

	keys = {
		{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
		{ "<Leader>fb", function() require("telescope").extensions.file_browser.file_browser() end, desc = "Browse files" },
	},

	config = function()
		require("telescope").setup({})
	end,
}
