return {
  "neovim/nvim-lspconfig",

  cmd = { "MasonToolsUpdate", "LspInfo", "LspStart", "LspStop", "LspRestart", "LspLog" },
  event = "BufReadPost",

  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neoconf.nvim",
    "folke/neodev.nvim",
  },

  keys = {
    { "<Leader>li", "<CMD>LspInfo<CR>", desc = "LSP info" },
    {
      "<Leader>?",
      function()
        vim.diagnostic.open_float()
      end,
      desc = "Show line diagnostic",
    },
  },

  config = function()
    require("neoconf").setup()
    require("neodev").setup()

    -- Define the virtual text diagnostic signs
    local signs = {
      Error = "",
      Warn = "",
      Hint = "󰌵",
      Info = "",
    }

    vim.diagnostic.config({
      virtual_text = {
        prefix = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            return signs["Error"]
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            return signs["Warning"]
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            return signs["Hint"]
          else
            return signs["Info"]
          end
        end,
      },
    })
    -----------

    local lspconfig = require("lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Add folding capabilities for nvim-ufo
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }

    require("mason-lspconfig").setup_handlers({
      function(server_name) -- default handler (optional)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,

      lua_ls = function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,

      --yamlls = function(server_name)
      --	lspconfig[server_name].setup({
      --		capabilities = capabilities
      --	})
      --end,

      terraformls = function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,

      pyright = function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,

      rust_analyzer = function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          settings = {
            rust_analyzer = {
              cargo = {
                extraEnv = { CARGO_PROFILE_RUST_ANALYZER_INHERITS = "dev" },
                extraArgs = { "--profile", "rust-analyzer" },
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        })
      end,

      gopls = function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              semanticTokens = true,
              completeUnimported = true,
            },
          },
          init_options = {
            usePlaceholders = true,
          },
        })
      end,
    })

    require("lspconfig.ui.windows").default_options.border = "single"

    -- Bootstrap lsp keymappings
    require("plugins.lsp.keymaps")
  end,
}
