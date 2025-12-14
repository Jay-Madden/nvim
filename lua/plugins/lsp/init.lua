return {
  "neovim/nvim-lspconfig",

  cmd = { "MasonToolsUpdate", "LspInfo", "LspStart", "LspStop", "LspRestart", "LspLog" },
  event = "BufReadPost",
  lazy = false,

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

    -- Custom lsp aucmd to support pep723 inline script metadata
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function(_)
        local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
        local has_inline_metadata = first_line:match("^# /// script")

        local cmd, name, root_dir
        if has_inline_metadata then
          local filepath = vim.fn.expand("%:p")
          local filename = vim.fn.fnamemodify(filepath, ":t")

          -- Set a unique name for the server instance based on the filename
          -- so we get a new client for new scripts
          name = "ty-" .. filename

          local relpath = vim.fn.fnamemodify(filepath, ":.")

          cmd = { "uvx", "--with-requirements", relpath, "ty", "server" }
          root_dir = vim.fn.fnamemodify(filepath, ":h")
        else
          name = "ty"
          cmd = { "uvx", "ty", "server" }
          root_dir = vim.fs.root(0, { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' })
        end

        vim.lsp.start({
          name = name,
          cmd = cmd,
          root_dir = root_dir,
        })
      end,
    })

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
        ['rust-analyzer'] = {
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

    require("lspconfig.ui.windows").default_options.border = "single"

    -- Bootstrap lsp keymappings
    require("plugins.lsp.keymaps")
  end,
}
