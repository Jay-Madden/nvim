local utils = require("utils")

-- Base mappings
utils.map("i", "jj", "<Esc>", { desc = "Double tap 'j' for normal mode" })

utils.map("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
utils.map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
utils.map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })

