---@type table<string, snacks.win?>
local active_terminals = {}

return {
  keys = {
    {
      "<leader>lg",
      function()
        Snacks.lazygit.open()
      end,
      desc = "LazyGit",
    },
    {
      "<leader>nt",
      function()
        Snacks.explorer.open({
          hidden = true,
          ignored = true,
        })
      end,
      desc = "File explorer",
    },
  },
  opts = {
    explorer = {
      replace_netrw = true,
      trash = true,
    },
    bigfile = { enabled = true },
    indent = { enabled = false },
    input = {},
    image = { enabled = true },
    lazygit = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      top_down = false,
      style = "fancy",
    },
    quickfile = { enabled = true },
    scroll = {
      animate = {
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
    },
    statuscolumn = {
      enabled = true,
      left = { "sign", "mark" },
      folds = {
        open = true,
        git_hl = true,
      },
    },
    terminal = {},
    words = { enabled = false },
  },
}
