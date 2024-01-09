return {
    "goolord/alpha-nvim",
    branch = "main",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        require("alpha").setup(require("alpha.themes.startify").config)
    end,
}

