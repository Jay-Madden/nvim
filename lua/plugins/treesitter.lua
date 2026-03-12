return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "grafana/vim-alloy",
  },

  config = function()
    local languages = {
      "go",
      "gomod",
      "gosum",
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
      -- For actions-preview picker
      "diff",
    }
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
        -- install() isn't available during lazy-loaded config; call it per-filetype instead
        require("nvim-treesitter").install(vim.bo.filetype)
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
        ["[Tt]iltfile%-.*"] = "tiltfile",
      },
    })
  end,
}
