return {
  "mfussenegger/nvim-lint",
  enabled = not require("utils").is_container(),

  event = "BufWritePost",

  config = function()
    require("lint").linters_by_ft = {
      go = { "golangcilint" },
    }
  end,
}
