return {
  "karb94/neoscroll.nvim",

  -- Enable neoscroll only if not using neovide
  enabled = function()
    return not vim.g.neovide
  end,

  config = function()
    require("neoscroll").setup({})
    local t = {}
    -- Syntax: t[keys] = {function, {function arguments}}
    t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "20" } }
    t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "20" } }
    t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "20" } }
    t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "20" } }
    t["<C-y>"] = { "scroll", { "-0.10", "false", "20" } }
    t["<C-e>"] = { "scroll", { "0.10", "false", "20" } }
    t["zt"] = { "zt", { "50" } }
    t["zz"] = { "zz", { "50" } }
    t["zb"] = { "zb", { "50" } }

    require("neoscroll.config").set_mappings(t)
  end,
}
