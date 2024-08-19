return {
  "Jay-Madden/auto-fix-return.nvim",
  branch = "update-query-terminate-shortvar",
  config = function()
    require("auto-fix-return").setup({
      enable_autocmds = true,
    })
  end
}

