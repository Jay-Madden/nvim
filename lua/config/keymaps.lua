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

-- Move Lines
utils.map("n", "<leader>mj", "<cmd>m .+1<cr>==", { desc = "Move down" })
utils.map("n", "<leader>mk", "<cmd>m .-2<cr>==", { desc = "Move up" })
utils.map("v", "<leader>mj", ":m '>+1<cr>gv=gv", { desc = "Move down" })
utils.map("v", "<leader>mk", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Window mappings

-- Move window focus using the <ctrl> hjkl keys
utils.map("n", "<C-h>", "<C-w>h", { desc = "Move focus to left window", remap = true })
utils.map("n", "<C-j>", "<C-w>j", { desc = "Move focus to lower window", remap = true })
utils.map("n", "<C-k>", "<C-w>k", { desc = "Move focus to upper window", remap = true })
utils.map("n", "<C-l>", "<C-w>l", { desc = "Move focus to right window", remap = true })

-- Resize window using <ctrl> arrow keys
utils.map("n", "<C-,>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
utils.map("n", "<C-m>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
utils.map("n", "<C-.>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
utils.map("n", "<C-n>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
