local utils = require("utils")

-- Lsp keymappings
utils.map("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "Go to implementation" })

utils.map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to definition" })

utils.map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "Go to declaration" })

utils.map("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Show information" })

utils.map("n", "<leader>r", function()
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  local popup_options = {
    relative = "cursor",
    position = {
      row = 1,
      col = 0,
    },
    size = 30,
    enter = true,
    focusable = false,
    border = {
      style = "rounded",
      text = {
        top = "Rename Symbol",
        top_align = "left",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  }

  local input = Input(popup_options, {
    prompt = "> ",
    on_submit = function(value)
      if value == "" then
        -- if we dont get a rename value bail out here
        return
      end
      vim.lsp.buf.rename(value)
    end,
  })

  input:mount()
  -- Close the popup when leaving the window
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end, { desc = "Show information" })
