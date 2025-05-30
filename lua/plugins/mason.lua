return {
  "mason-org/mason.nvim",
  cmd = { "MasonToolsUpdate" },

  dependencies = {
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
      "clangd",
      "pyright",
      -- Golang
      "gopls",
      "golangci-lint",
      --------
      "bash-language-server",
      "ts_ls",
      "html-lsp",
    }

    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
    })
  end,
}
