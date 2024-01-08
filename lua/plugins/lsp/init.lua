return {
	"neovim/nvim-lspconfig",
	event = { "InsertEnter", "CmdlineEnter" },
	cmd = { "MasonToolsUpdate" },

	 dependencies = {
		 "williamboman/mason.nvim",
		 "williamboman/mason-lspconfig.nvim",
		 "WhoIsSethDaniel/mason-tool-installer.nvim",
		  "folke/neoconf.nvim",
			"folke/neodev.nvim",
	 },

	 config = function()
		 local tools = {
			 "lua-language-server",
			 "yaml-language-server"
		 }

		 require("neoconf").setup()
		 require("neodev").setup()

		 require("mason").setup()
		 require("mason-lspconfig").setup()

		 require("mason-tool-installer").setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
    })

		local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		require('lspconfig')["lua_ls"].setup({
			capabilities = capabilities,
		})

		require("lspconfig")["yamlls"].setup({
			capabilities = capabilities
		})

		require("lspconfig.ui.windows").default_options.border = "single"

		end,
}
