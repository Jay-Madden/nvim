return {
  "neovim/nvim-lspconfig",

  cmd = { "MasonToolsUpdate", "LspInfo", "LspStart", "LspStop", "LspRestart", "LspLog" },
  event = "BufReadPost",
  lazy = false,

  dependencies = {
    "Jay-Madden/tylsp-pep723.nvim",
    "mason-org/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neoconf.nvim",
  },

  keys = {
    { "<Leader>li", "<CMD>LspInfo<CR>", desc = "LSP info" },
    {
      "<Leader>?",
      function()
        vim.diagnostic.config({
          float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
          },
        })
        vim.diagnostic.open_float()
      end,
      desc = "Show line diagnostic",
    },
  },

  config = function()
    vim.opt.rtp:append(vim.fn.stdpath("config") .. "/nvim-lspconfig")
    vim.opt.rtp:append(vim.fn.stdpath("config") .. "/mason.nvim")

    require("neoconf").setup()

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

    -- Currently copilot.lua embeds a language server config
    -- so we dont need this here, but leaving this as a config example
    -- vim.lsp.config("copilot_ls", {
    --   -- Command and arguments to start the server.
    --   cmd = { "node", "/Users/jcox/.local/share/nvim/lazy/copilot.lua/copilot/js/language-server.js", "--stdio" },
    -- })
    -- vim.lsp.enable("copilot_ls")

    vim.lsp.enable("lua_ls")

    -- vim.lsp.enable("yamlls")
    vim.lsp.enable("terraformls")

    -- ##### Python #####
    require("tylsp-pep723").setup({})

    -- Old pyright configuration
    -- vim.lsp.config("pyright", {
    --   settings = {
    --     pyright = {
    --       venv = ".venv",
    --     },
    --   },
    -- })
    -- vim.lsp.enable("pyright")
    -- #####

    vim.lsp.enable("vtsls")

    -- vim.lsp.enable("html")
    -- vim.lsp.enable("clangd")

    vim.lsp.enable("bashls")

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = true,
          check = {
            command = "clippy",
            workspace = true,
            -- features = "all",
          },
        },
      },
    })
    vim.lsp.enable("rust_analyzer")

    vim.lsp.config("gopls", {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
        usePlaceholders = false,
      },
    })

    vim.lsp.enable("gopls")
    vim.lsp.config("buf", {})
    vim.lsp.enable("buf")


    vim.lsp.config("jdtls", {})
    vim.lsp.enable('jdtls')

    require("lspconfig.ui.windows").default_options.border = "single"

    -- Bootstrap lsp keymappings
    require("plugins.lsp.keymaps")
  end,
}
