return {
  "folke/sidekick.nvim",
  enabled = true,
  keys = {
    {
      "<leader>ca",
      function()
        require("sidekick").nes_jump_or_apply()
      end,
      expr = true,
      desc = "Goto/Apply Previous Edit Suggestion",
      mode = { "n", "x", "i" },
    },
    {
      "<leader>cn",
      function()
        require("sidekick.nes").update()
      end,
      expr = true,
      desc = "Request a suggestion",
      mode = { "n", "x", "i" },
    },
    {
      "<leader>cd",
      function()
        require("sidekick.nes").clear()
      end,
      desc = "Clear copilot suggestions",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select({ filter = { installed = true } })
      end,
      -- Or to select only installed tools:
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
  opts = {
    debug = true,
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      default = "cursor",
    },
    nes = {
      enabled = true,
    },
  },
}
