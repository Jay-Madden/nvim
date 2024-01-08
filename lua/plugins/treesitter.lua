return {
	"nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  cmd = { "TSUpdateSync" },

	auto_install = true,

	dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

	opts = {
		ensure_installed = {
			"c",
			"lua",
			"yaml",
			"vimdoc",
			"vim",
			"regex",
			"bash",
			"markdown",
			"markdown_inline",
		},
	},

	highlight = {
    enable = true,
	},
}

