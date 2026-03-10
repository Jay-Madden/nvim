return {
  "nvim-tree/nvim-web-devicons",
  opts = {
    override_by_filename = {
      ["go.mod"] = {
        icon = "",
        color = "#00ADD8",
        name = "GoMod",
      },
      ["go.sum"] = {
        icon = "",
        color = "#00ADD8",
        name = "GoSum",
      },
    },
  },
}
