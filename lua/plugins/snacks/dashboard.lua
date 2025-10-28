return {
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[
         ██╗      ██╗   ██╗██╗███╗   ███╗
         ██║      ██║   ██║██║████╗ ████║
         ██║█████╗╚██╗ ██╔╝██║██╔████╔██║
    ██╗  ██║╚════╝ ╚████╔╝ ██║██║╚██╔╝██║
    ╚█████╔╝        ╚██╔╝  ██║██║ ╚═╝ ██║
     ╚════╝          ╚═╝   ╚═╝╚═╝     ╚═╝]],
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = function()
              Snacks.picker.files({
                hidden = true,
                ignore = true,
              })
            end,
          },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = function()
              Snacks.picker.grep()
            end,
          },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Plugins",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          {
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
