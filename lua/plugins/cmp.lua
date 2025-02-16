return {
  "hrsh7th/nvim-cmp",
  event = { "VeryLazy", "InsertEnter" },
  dependencies = {
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "onsails/lspkind.nvim",
    {
      "L3MON4D3/LuaSnip",
      config = function()
        require("luasnip").setup()
      end,
    },
    "xzbdmw/colorful-menu.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- show only symbol annotations
          ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default
          before = function(entry, vim_item)
            local highlights_info = require("colorful-menu").cmp_highlights(entry)

            -- highlight_info is nil means we are missing the ts parser, it's
            -- better to fallback to use default `vim_item.abbr`. What this plugin
            -- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
            if highlights_info ~= nil then
                vim_item.abbr_hl_group = highlights_info.highlights
                vim_item.abbr = highlights_info.text
            end

            return vim_item
          end,
        }),
      },

      window = {
        completion = cmp.config.window.bordered({ border = "rounded" }),
        documentation = cmp.config.window.bordered({ border = "rounded" }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      }),

      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            -- filter out useless text completion items we only want semantic entries
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
          keyword_length = 1,
        },
        { name = "nvim_lua" },
        { name = "luasnip" },
      }),
    })
  end,
}
