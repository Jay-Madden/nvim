return {
  "ray-x/go.nvim",
  event = {"CmdlineEnter"},
  ft = {"go", "gomod"},
  build = ':lua require("go.install").update_all_sync()',

  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
		local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    require("go").setup({
			lsp_cfg = {
				capabilities = capabilities,
			},
		})
  end,
}


