return {
  "Jay-Madden/auto-fix-return.nvim",
  config = function()
    require("auto-fix-return").setup({
      enable_autocmds = true,
    })
  end,
}
