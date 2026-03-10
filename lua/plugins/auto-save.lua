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
    })
  end,
}
