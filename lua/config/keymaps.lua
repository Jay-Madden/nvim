local map = function(mode, lhs, rhs, opts)
  vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Base mappings
map("i", "jj", "<Esc>", { desc = "Double tap 'j' for normal mode" })
