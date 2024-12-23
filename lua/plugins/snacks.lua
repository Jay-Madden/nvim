return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    indent = { enabled = false },
    input = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
    },
    statuscolumn = { enabled = false },
    words = { enabled = false },
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
      },
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e square",
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Diff",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git --no-pager diff --stat -B -M -C",
          height = 10,
        },
        { section = "startup" },
      },
    }
  }
}

