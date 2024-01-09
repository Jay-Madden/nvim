return {
	"akinsho/toggleterm.nvim",

	 keys = {
		 { "<Leader>t", "<CMD>ToggleTerm direction=float<CR>", desc = "Open floating terminal" },
	 },

	config = function()
		require("toggleterm").setup()
	end,
}

