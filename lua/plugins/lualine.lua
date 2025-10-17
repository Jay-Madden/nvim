return {
  "nvim-lualine/lualine.nvim",

  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local lualine = require("lualine")
    local kanagawa_colors = require("kanagawa.colors").setup()
    local palette_colors = kanagawa_colors.palette

    local colors = {
      blue = "#80a0ff",
      cyan = "#79dac8",
      black = "#080808",
      white = "#c6c6c6",
      red = "#ff5189",
      violet = "#d183e8",
      grey = "#303030",
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = palette_colors.springGreen },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = palette_colors.sumiInk3 },
      },

      insert = { a = { fg = colors.black, bg = palette_colors.crystalBlue } },
      visual = { a = { fg = colors.black, bg = palette_colors.sakuraPink } },
      replace = { a = { fg = colors.black, bg = colors.red } },

      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.black, bg = colors.black },
      },
    }

    lualine.setup({
      options = {
        theme = bubbles_theme,
        component_separators = "|",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "snacks_dashboard", "Alpha", "NVimTree" },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { "branch", "filename", "diagnostics",
          {
            separator = { right = "" },
            function()
              return ""
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                if status.kind == "Error" then
                  return { bg = palette_colors.autumnRed }
                end

                -- return nil to use the default bg color
                return nil
              end
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "fileformat", "filetype", "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
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
