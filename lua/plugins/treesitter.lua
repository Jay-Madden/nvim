return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "grafana/vim-alloy",
  },

  config = function()
    local languages = {
      "go",
      "rust",
      "lua",
      "python",
      "c",
      "cpp",
      "java",
      "c_sharp",
      "wgsl",
      "javascript",
      "typescript",
      "bash",
      "json",
      "yaml",
      "markdown",
      "helm",
    }
    require("nvim-treesitter").install(languages)

    require("treesitter-context").setup({
      multiwindow = true,
      multiline_threshold = 5,
      trim_scope = "outer",
      separator = "─"
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- folds, provided by Neovim
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
