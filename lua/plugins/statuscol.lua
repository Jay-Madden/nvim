return {
  "luukvbaal/statuscol.nvim",

  config = function()
    local builtin = require("statuscol.builtin")
    local segments = {
      {
        sign = {
          name = { "[DapBreakpoint|Marks*]" },
          maxwidth = 1,
        },
        click = "v:lua.ScSa",
      },
      {
        sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
        click = "v:lua.ScSa",
      },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    }

    -- Check if the current directory is a git repo, if it is show the gitsigns in the gutter
    local current_rev = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
    if current_rev ~= "" then
      table.insert(segments, {
        sign = {
          namespace = { "gitsign" },
          maxwidth = 1,
        },
        click = "v:lua.ScSa",
      })
    end

    table.insert(segments, {
      sign = {
        name = { ".*" },
        maxwidth = 1,
        colwidth = 1,
        wrap = true,
        auto = true,
      },
      click = "v:lua.ScSa",
    })

    local setup_table = {
      relculright = true,
      segments = segments,
    }
    require("statuscol").setup(setup_table)
  end,
}
