return {
  "neovim/nvim-lspconfig",

  cmd = { "MasonToolsUpdate", "LspInfo", "LspStart", "LspStop", "LspRestart", "LspLog" },
  event = "BufReadPost",

  dependencies = {
    "mason-org/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neoconf.nvim",
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
    vim.opt.rtp:append(vim.fn.stdpath("config") .. "/nvim-lspconfig")
    vim.opt.rtp:append(vim.fn.stdpath("config") .. "/mason.nvim")

    -- Add the same capabilities to ALL server configurations.
    -- Refer to :h vim.lsp.config() for more information.
    vim.lsp.config("*", {
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      root_markers = { ".git" },
    })

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
    vim.lsp.config("lua_ls", {
      -- Command and arguments to start the server.
      cmd = { "lua-language-server" },
      -- Filetypes to automatically attach to.
      filetypes = { "lua" },
      settings = {
        Lua = {
          root_markers = { ".git", "*.rockspec" },
        },
      },
    })
    vim.lsp.enable("lua_ls")
    --
    -- vim.lsp.enable("yamlls")
    -- vim.lsp.enable("terraformls")

    vim.lsp.config("pyright", {
      settings = {
        pyright = {
          venv = ".venv",
        },
      },
    })
    vim.lsp.enable("pyright")

    vim.lsp.config("tsserver", {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
        }
    })
    vim.lsp.enable("tsserver")
    -- vim.lsp.enable("html")
    -- vim.lsp.enable("clangd")
    -- vim.lsp.enable("bashls")

    vim.lsp.config("rust_analyzer", {
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

    require("lspconfig.ui.windows").default_options.border = "single"

    -- Bootstrap lsp keymappings
    require("plugins.lsp.keymaps")
  end,
}
