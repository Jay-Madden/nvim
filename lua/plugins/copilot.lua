return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  enabled = function()
    return true
    -- return vim.fn.executable("copilot-language-server") == 1
  end,
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = false,
        auto_refresh = true,
        keymap = {
          accept = "<leader>ca",
          next = "<leader>cn",
          prev = "<leader>ccp",
          dismiss = "<leader>ccd",
        },
      },
      -- Currently the copilot.lua installation for cls is broken for some reason
      -- if we use the npm install version as of this commit it works.
      -- https://github.com/zbirenbaum/copilot.lua/issues/591
      -- TODO: Remove this
      server = {
        type = "binary",
        custom_server_filepath = "/opt/homebrew/bin/copilot-language-server",
      },
    })
  end,
}
