return {
  "nvim-lualine/lualine.nvim",

  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local lualine = require("lualine")
    local kanagawa_colors = require("kanagawa.colors").setup()
    local palette_colors = kanagawa_colors.palette

    local muted = { fg = kanagawa_colors.theme.ui.nontext, bg = palette_colors.sumiInk3 }

    local theme = {
      normal = {
        a = { fg = palette_colors.springGreen, bg = muted.bg },
        b = muted,
        c = muted,
        z = muted,
      },
      insert = {
        a = { fg = palette_colors.crystalBlue, bg = muted.bg },
        z = muted,
      },
      visual = {
        a = { fg = palette_colors.sakuraPink, bg = muted.bg },
        z = muted,
      },
      replace = {
        a = { fg = "#ff5189", bg = muted.bg },
        z = muted,
      },
      inactive = {
        a = muted,
        b = muted,
        c = muted,
        z = muted,
      },
    }

    lualine.setup({
      options = {
        theme = theme,
        component_separators = "|",
        section_separators = "",
        disabled_filetypes = { "snacks_dashboard", "Alpha", "NVimTree" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          { "filename", path = 1 },
          { "diagnostics", colored = false },
          {
            function()
              return ""
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "fileformat", { "filetype", colored = false }, "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })
  end,
}
