local M = {
  "goolord/alpha-nvim",
  enabled = true,
  branch = "main",

  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
         ██╗      ██╗   ██╗██╗███╗   ███╗
         ██║      ██║   ██║██║████╗ ████║
         ██║█████╗╚██╗ ██╔╝██║██╔████╔██║
    ██╗  ██║╚════╝ ╚████╔╝ ██║██║╚██╔╝██║
    ╚█████╔╝        ╚██╔╝  ██║██║ ╚═╝ ██║
     ╚════╝          ╚═╝   ╚═╝╚═╝     ╚═╝
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       [[<cmd> lua require("telescope.builtin").find_files() <cr>]]),
      dashboard.button("r", " " .. " Restore Session", [[<cmd> lua require("plugins.alpha").restore() <cr>]]),
      dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("s", " " .. " Recent files",    [[<cmd> lua require("telescope.builtin").oldfiles() <cr>]]),
      dashboard.button("g", " " .. " Find text",       [[<cmd> lua require("telescope.builtin").live_grep() <cr>]]),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8

    return dashboard
  end,

  config = function(_, dashboard)
    require("alpha").setup(dashboard.opts)
  end,
}

-- Function to restore the neotree window from the persistence session without messing up state
function M.restore()
  -- Restore the last session
  require("persistence").load()

  -- Toggle neotree
  vim.cmd("Neotree")

  -- Go back to the previous buffer after we load the session which is the active window
  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()

  for i, buffer in ipairs(buffers) do
    if buffer == current_buffer and i > 1 then
      vim.api.nvim_set_current_buf(buffers[i - 1])
      break
    end
  end
end

return M
