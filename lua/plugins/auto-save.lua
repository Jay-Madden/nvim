return {
  "Pocco81/auto-save.nvim",
  enabled = true,

  config = function()
    require("auto-save").setup({
      execution_message = {
        message = function()
          return ""
        end,
      },
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
      pre_save = nil, -- a function to call before saving the session
      save_empty = false, -- don't save if there are no open file buffers
    })
  end,
}
