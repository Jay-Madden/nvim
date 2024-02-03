return {
  "williamboman/mason.nvim",
  cmd = { "MasonToolsUpdate" },

  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },


  config = function()
    local tools = {
      "lua-language-server",
      "rust-analyzer",
      "terraform-ls",
      -- Rust debugger
      "codelldb",
      --------
      "pyright",
      "gopls",
    }

    require("mason").setup()
    require("mason-lspconfig").setup()

    require("mason-tool-installer").setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
    })

  end,


}

