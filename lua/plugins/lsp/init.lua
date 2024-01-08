local setup_lsp = function(server_name, opts)
	require("lspconfig")[server_name].setup({
		capabilities = options.capabilities
	})
end

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

	 keys = {
		 { "<Leader>li", "<CMD>LspInfo<CR>", desc = "LSP info" },
	 },

	 config = function()
		 local tools = {
			 "lua-language-server",
			 "yaml-language-server",
			 "pyright",
			 "gopls",
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

		local lspconfig = require("lspconfig")

		local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		require("mason-lspconfig").setup_handlers({
		  function(server_name) -- default handler (optional)
			  lspconfig[server_name].setup({
					capabilities = capabilities
				})
		  end,

			lua_ls = function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities
				})
			end,

			yamlls = function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities
				})
			end,

			gopls = function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities
				})
			end,

		})

		require("lspconfig.ui.windows").default_options.border = "single"

		-- Bootstrap lsp keymappings
		require("plugins.lsp.keymaps")

		end,
}
