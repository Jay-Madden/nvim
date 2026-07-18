return {
  "neovim/nvim-lspconfig",

  cmd = { "LspStart", "LspStop", "LspRestart", "LspLog" },
  event = "BufEnter",

  dependencies = {
    "Jay-Madden/tylsp-pep723.nvim",
    "folke/neoconf.nvim",
  },

  keys = {
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
            return signs["Warn"]
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

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            groupFileStatus = {
              ambiguity = "Any",
              duplicate = "Any",
              global = "Any",
              luadoc = "Any",
              redefined = "Any",
              ["type-check"] = "Any",
              unbalanced = "Any",

              await = "Opened",
              strict = "Opened",
              unused = "Opened",

              codestyle = "None",
              conventions = "None",
              strong = "None",
            },
            workspaceEvent = "OnChange",
            workspaceDelay = 200,
            workspaceRate = 100,
          },
          workspace = {
            checkThirdParty = false,
            -- Keep project files diagnostic-enabled while loading external API types.
            library = {
              vim.env.VIMRUNTIME,
              vim.fn.stdpath("data") .. "/lazy/luvit-meta/library",
              vim.fn.stdpath("data") .. "/lazy/snacks.nvim/lua",
            },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    -- vim.lsp.enable("yamlls")
    vim.lsp.enable("terraformls")

    -- ##### Python #####
    require("tylsp-pep723").setup({})
    -- vim.lsp.config("ruff", {})
    -- vim.lsp.enable("ruff")

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

    vim.lsp.config("vtsls", {})
    vim.lsp.enable("vtsls")

    -- vim.lsp.enable("html")
    -- vim.lsp.enable("clangd")

    vim.lsp.enable("bashls")

    vim.lsp.config("zls", {
      settings = {
        zls = {
          build_on_save_args = { "-fincremental" },
        },
      },
    })
    vim.lsp.enable("zls")

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
          fileWatcher = "fsnotify",
          diagnosticsTrigger = "Edit",
          diagnosticsDelay = "200ms",
          analyses = {
            unusedparams = true,
            shadow = false,
          },
          staticcheck = false,
          gofumpt = true,
          completeUnimported = true,
        },
      },
      init_options = {
        usePlaceholders = false,
        semanticTokens = true,
      },
    })
    vim.lsp.enable("gopls")

    -- gopls rejects full semanticTokens for files >100KB, so Neovim falls
    -- back to range requests per viewport. Pad the range so small scrolls
    -- stay inside the already-fetched window and don't flash.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "gopls" then
          return
        end
        if client._semtok_range_padded then
          return
        end
        client._semtok_range_padded = true

        local PAD = 300
        local orig_request = client.request
        client.request = function(self, method, params, handler, req_bufnr)
          if
            method == "textDocument/semanticTokens/range"
            and type(params) == "table"
            and params.range
          then
            local bufnr = req_bufnr or vim.api.nvim_get_current_buf()
            local line_count = vim.api.nvim_buf_line_count(bufnr)
            params.range["start"].line = math.max(0, params.range["start"].line - PAD)
            params.range["start"].character = 0
            params.range["end"].line = math.min(line_count - 1, params.range["end"].line + PAD)
            params.range["end"].character = 0
          end
          return orig_request(self, method, params, handler, req_bufnr)
        end
      end,
    })

    -- Swift lsp support
    vim.lsp.config("sourcekit", {})
    vim.lsp.enable("sourcekit")

    vim.lsp.config("buf_ls", {})
    vim.lsp.enable("buf_ls")

    vim.lsp.config("wgsl_analyzer", {})
    vim.lsp.enable("wgsl_analyzer")

    vim.lsp.config("jdtls", {})
    vim.lsp.enable("jdtls")

    vim.lsp.config("tilt_ls", {
      filetypes = { "tiltfile" },
    })
    vim.lsp.enable("tilt_ls")

    require("lspconfig.ui.windows").default_options.border = "single"

    -- Bootstrap lsp keymappings
    require("plugins.lsp.keymaps")
  end,
}
