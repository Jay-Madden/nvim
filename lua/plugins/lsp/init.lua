return {
	"neovim/nvim-lspconfig",
	event = { "VeryLazy" },
	cmd = { "MasonToolsUpdate" },

	 dependencies = { 
		 "williamboman/mason.nvim",
		 "williamboman/mason-lspconfig.nvim",
		 "WhoIsSethDaniel/mason-tool-installer.nvim",
	 },

	 config = function()
		 local tools = {
			 "lua-language-server",
		 }

		 require("mason").setup()
		 require("mason-lspconfig").setup()

		 require("mason-tool-installer").setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
    })

		require("lspconfig").lua_ls.setup({})
		end,
}
