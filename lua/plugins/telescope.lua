return {
	"nvim-telescope/telescope.nvim",

	dependencies = { 
		"nvim-lua/plenary.nvim", 
		"nvim-telescope/telescope-symbols.nvim",
	},

	keys = {
		{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
	},	

	config = function()
		require("telescope").setup()
	end,
}
