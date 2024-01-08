return {
	"lewis6991/gitsigns.nvim",

	config = function()
		require("gitsigns").setup({
			-- We need this temporarily so that statuscolumn will work correctly
			_extmark_signs = false,

			signs = {
				add          = { text = '│' },
				change       = { text = '│' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},

			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
		})
	end,
}

