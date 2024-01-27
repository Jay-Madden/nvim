local utils = require("utils")

-- Lsp keymappings
utils.map("n", "gi", function() vim.lsp.buf.implementation() end, { desc = "Go to implementation" })
utils.map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
utils.map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })
utils.map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Show information" })
