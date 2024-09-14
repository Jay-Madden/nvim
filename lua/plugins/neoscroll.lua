return {
  "karb94/neoscroll.nvim",

  -- Enable neoscroll only if not using neovide
  enabled = function()
    return not vim.g.neovide
  end,

  config = function()
    require("neoscroll").setup({})
    local neoscroll = require('neoscroll')
    local keymap = {}

    keymap["<C-u>"] = function() neoscroll.ctrl_u({duration = 20}) end
    keymap["<C-d>"] = function() neoscroll.ctrl_d({duration = 20}) end
    keymap["<C-b>"] = function() neoscroll.ctrl_b({duration = 20}) end
    keymap["<C-f>"] = function() neoscroll.ctrl_f({duration = 20}) end
    keymap["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 20 }) end;
    keymap["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 20 }) end;
    keymap["zt"]    = function() neoscroll.zt({ half_win_duration = 50 }) end;
    keymap["zz"]    = function() neoscroll.zz({ half_win_duration = 50 }) end;
    keymap["zb"]    = function() neoscroll.zb({ half_win_duration = 50 }) end;

    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
