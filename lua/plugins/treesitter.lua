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
      "tiltfile",
    }
    require("nvim-treesitter").install(languages)

    require("treesitter-context").setup({
      multiwindow = true,
      multiline_threshold = 5,
      trim_scope = "outer",
      separator = "─",
    })

    -- starlark is python-based
    vim.treesitter.language.register("python", "tiltfile")

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
    vim.filetype.add({
      extension = {
        gotmpl = "gotmpl",
      },
      filename = {
        ["Tiltfile"] = "tiltfile",
        ["tiltfile"] = "tiltfile",
      },
      pattern = {
        [".*%.tm?pl"] = "helm",
        [".*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
        ["[Tt]iltfile%-.*"] = "tiltfile",
      },
    })
  end,
}
