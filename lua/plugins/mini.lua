return {
  "echasnovski/mini.nvim",
  event = "BufReadPost",

  config = function()
    require("mini.surround").setup()
    require("mini.ai").setup()
    require("mini.trailspace").setup()

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        MiniTrailspace.trim()
      end,
    })
  end,
}
