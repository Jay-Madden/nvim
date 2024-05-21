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
        return {
          -- Handle floating windows correctly
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          -- Highlight rust string placeholders
          ["@lsp.type.formatSpecifier.rust"] = { fg = theme.syn.keyword },

          -- Highlight bufferline background as kanagawa theme
          BufferlineFill = { bg = colors.palette.sumiInk0 },
          BufferlineBackground = { bg = colors.palette.sumiInk0 },
        }
      end,
    })

    require("kanagawa").load("wave")
  end,
}
