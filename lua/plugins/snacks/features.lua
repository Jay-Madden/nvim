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
        local auto_width = true
        local default_width = 40
        Snacks.explorer.open({
          hidden = true,
          ignored = true,
          layout = { layout = { width = default_width } },
          win = {
            list = { keys = { ["<c-e>"] = "toggle_width" } },
            input = { keys = { ["<c-e>"] = { "toggle_width", mode = { "n", "i" } } } },
          },
          actions = {
            toggle_width = function(picker)
              auto_width = not auto_width
              picker.opts.on_change(picker)
            end,
          },
          on_change = function(picker)
            if not picker.shown or picker.closed or picker.layout.opts.fullscreen then
              return
            end

            local width = default_width
            if auto_width then
              local highlight = Snacks.picker.highlight
              for i = picker.list.top, picker.list.top + picker.list:height() - 1 do
                local line = picker.format(picker.list:get(i), picker)
                line = highlight.resolve(line, math.huge)
                width = math.max(width, highlight.offset(line, { char_idx = true }) + 3)
              end
              width = math.min(width, math.floor(vim.o.columns / 2))
            end

            local win = picker.layout.root.win
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_width(win) ~= width then
              vim.api.nvim_win_set_width(win, width)
              picker.layout:update()
            end
          end,
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
