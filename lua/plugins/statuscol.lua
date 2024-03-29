return {
  "luukvbaal/statuscol.nvim",
  branch = "0.10",

  dependencies = {
    "lewis6991/gitsigns.nvim",
  },

  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        {
          sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
          click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        {
          sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, wrap = true },
          click = "v:lua.ScSa",
        },
      },
    })
  end,
}
