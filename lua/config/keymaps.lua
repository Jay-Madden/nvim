-- Some mappings inspired by https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local utils = require("utils")

-- Base mappings
utils.map("i", "jj", "<Esc>", { desc = "Double tap 'j' for normal mode" })

-- better up/down
utils.map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
utils.map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
utils.map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
utils.map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Allow for multiple indents with a single selection
utils.map("v", "<", "<gv", { desc = "Better indenting" })
utils.map("v", ">", ">gv", { desc = "Better indenting" })

-- Window mappings

-- Move to window using the <ctrl> hjkl keys
utils.map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
utils.map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
utils.map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
utils.map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
utils.map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
utils.map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
utils.map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
utils.map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
