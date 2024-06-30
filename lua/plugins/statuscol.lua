return {
  "luukvbaal/statuscol.nvim",

  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        {
          sign = {
            name = { "DapBreakpoint" },
            maxwidth = 1,
          },
          click = "v:lua.ScSa",
        },
        {
          sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
          click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        {
          sign = {
            namespace = { "gitsign" },
            auto = true,
            maxwidth = 1,
          },
          click = "v:lua.ScSa",
        },
        {
          sign = {
            name = { ".*" },
            maxwidth = 1,
            colwidth = 1,
            wrap = true,
          },
          click = "v:lua.ScSa",
        },
      },
    })
  end,
}
