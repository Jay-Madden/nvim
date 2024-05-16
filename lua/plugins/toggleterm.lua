---@type table<string, Terminal|nil>
local active_terminals = {}

return {
  "akinsho/toggleterm.nvim",

  keys = {
    {
      "<Leader>tt",
      function()
        TOGGLE_VERTICAL_TERMINAL()
      end,
      desc = "Open floating terminal",
    },
    {
      "<Leader>tn",
      "<C-\\><C-n>",
      mode = "t",
      desc = "Go to normal mode from toggleterm",
    },
    {
      "<Leader>te",
      function()
        local Input = require("nui.input")
        local event = require("nui.utils.autocmd").event

        local popup_options = {
          relative = "cursor",
          position = {
            row = 1,
            col = 0,
          },
          size = 70,
          enter = true,
          focusable = false,
          border = {
            style = "rounded",
            text = {
              top = "Execute Command",
              top_align = "left",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal",
          },
        }

        local input = Input(popup_options, {
          prompt = "$ ",
          -- default the prompt to the word under the cursor
          on_submit = function(value)
            if value == "" then
              -- if we dont get a rename value bail out here
              return
            end

            -- Get the current working directory so we can send the command to the correct terminal
            local cwd = vim.uv.cwd()

            if active_terminals[cwd] == nil then
              -- If we dont have an active terminal then for now we bail out
              -- we can be smarter about this later
              return
            end

            -- We use zsh vim mode so we need to send our custom vim escape sequence to go to normal mode
            -- then back to insert mode before we send the command
            -- this handles the terminal in both normal and insert mode
            active_terminals:send("jji" .. value, true)
          end,
        })

        input:mount()
        -- Close the popup when leaving the window
        input:on(event.BufLeave, function()
          input:unmount()
        end)
      end,
      desc = "Execute a command in the terminal and return to the current buffer",
    },
  },

  config = function()
    require("toggleterm").setup({
      size = 80,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    ---@diagnostic disable-next-line: missing-global-doc
    function TOGGLE_VERTICAL_TERMINAL()
      -- Add the terminal to the correct cwd path
      local cwd = vim.uv.cwd()
      if active_terminals[cwd] == nil then
        active_terminals[cwd] = Terminal:new({
          direction = "vertical",
          hidden = true,
          on_exit = function()
            active_terminals[cwd] = nil
          end,
        })
      end


      active_terminals[cwd]:toggle()
    end
  end,
}
