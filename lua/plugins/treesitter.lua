return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  cmd = { "TSUpdateSync" },

  auto_install = true,

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "go",
        "cpp",
        "lua",
        "yaml",
        "rust",
        "vimdoc",
        "vim",
        "regex",
        "bash",
        "python",
        "markdown",
        "markdown_inline",
        "terraform",
      },

      modules = {},

      ignore_install = {},

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      highlight = {
        enable = true,
      },
    })

    require("treesitter-context").setup({
      mode = "topline",
      -- Only show the definition name for a given context instead of everything
      multiline_threshold = 1,
    })

    -- Setup language detection for tmpl files
    vim.filetype.add({
      extension = {
        gotmpl = "gotmpl",
      },
      pattern = {
        [".*%.tm?pl"] = "helm",
        [".*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
      },
    })
  end,
}
