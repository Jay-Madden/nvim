return {
  "hrsh7th/nvim-cmp",
	event = { "VeryLazy", "InsertEnter" },
	dependencies = {
	  "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
		{
			"L3MON4D3/LuaSnip",
			config = function()
        require("luasnip").setup()
      end,
		},
	},

	config = function()
		local cmp = require("cmp")
		cmp.setup({
		  snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				end,
		  },

		  window = {
			  completion = cmp.config.window.bordered({ border = "rounded" }),
			  documentation = cmp.config.window.bordered({ border = "rounded" }),
			},

      mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),

			sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "buffer" },
      }),
		})
	end,
}
