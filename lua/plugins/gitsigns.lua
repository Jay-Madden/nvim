return {
	"lewis6991/gitsigns.nvim",

	config = function()
		require("gitsigns").setup({
			_extmark_signs = false
		})
	end,
}

