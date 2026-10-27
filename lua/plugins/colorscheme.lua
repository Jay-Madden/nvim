return {
  "rebelot/kanagawa.nvim",

  config = function()
    local kanagawa = require("kanagawa")

    kanagawa.setup({
      commentStyle = {
        italic = false,
      },
      keywordStyle = {
        italic = false,
      },
      colors = {
        palette = {
          sumiInk3 = "#22222C",
        },
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        local popup_bg = theme.ui.bg_p1
        return {
          -- Handle floating windows correctly
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          DiffText = { bg = theme.diff.text },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          SnacksPicker = { bg = popup_bg, fg = theme.ui.fg_dim },
          SnacksPickerBorder = { bg = popup_bg, fg = popup_bg },
          SnacksPickerInputBorder = { bg = popup_bg, fg = popup_bg },
          SnacksPickerCursorLine = { bg = theme.ui.bg_p2 },
          SnacksNotifierTrace = { bg = popup_bg, fg = theme.ui.fg },
          SnacksNotifierBorderTrace = { bg = popup_bg, fg = popup_bg },
          SnacksNotifierDebug = { bg = popup_bg, fg = theme.ui.fg },
          SnacksNotifierBorderDebug = { bg = popup_bg, fg = popup_bg },
          SnacksNotifierInfo = { bg = popup_bg, fg = theme.ui.fg },
          SnacksNotifierBorderInfo = { bg = popup_bg, fg = popup_bg },
          SnacksNotifierWarn = { bg = popup_bg, fg = theme.ui.fg },
          SnacksNotifierBorderWarn = { bg = popup_bg, fg = popup_bg },
          SnacksNotifierError = { bg = popup_bg, fg = theme.diag.error },
          SnacksNotifierBorderError = { bg = popup_bg, fg = popup_bg },
          NoiceCmdline = { link = "SnacksPicker" },
          NoiceCmdlinePopup = { link = "SnacksPicker" },
          NoiceCmdlinePopupBorder = { bg = popup_bg, fg = popup_bg },
          NoiceCmdlinePopupBorderSearch = { bg = popup_bg, fg = popup_bg },
          NoicePopup = { bg = popup_bg, fg = theme.ui.fg_dim },
          NoicePopupBorder = { bg = popup_bg, fg = popup_bg },
          NoicePopupmenu = { bg = popup_bg, fg = theme.ui.fg_dim },
          NoicePopupmenuBorder = { bg = popup_bg, fg = popup_bg },
          NoicePopupmenuSelected = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
          NoiceConfirm = { bg = popup_bg, fg = theme.ui.fg_dim },
          NoiceConfirmBorder = { bg = popup_bg, fg = popup_bg },

          -- Highlight rust string placeholders
          ["@lsp.type.formatSpecifier.rust"] = { fg = theme.syn.keyword },
        }
      end,
    })

    ------- Manual Overrides -------

    -- Disable semantic highlighting of keywords for go and zig so the treesitter rule for return statements takes priority
    vim.api.nvim_set_hl(0, "@lsp.type.keyword.go", {})
    vim.api.nvim_set_hl(0, "@lsp.type.keyword.zig", {})

    -------

    require("kanagawa").load("wave")
  end,
}
