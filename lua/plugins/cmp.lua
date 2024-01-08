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

			-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
			mapping = {
				["<Tab>"] = cmp.mapping(function(fallback)
				-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						cmp.confirm()
					end
				else
					fallback()
				end
			end, {"i","s","c",}),
			},

			sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "buffer" },
      }),
		})
	end,
}
