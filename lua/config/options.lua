vim.opt.number = true

vim.g.mapleader = ";"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Show the gitsigns status to the right of the numbers instead of to the left
-- vim.opt.statuscolumn = '%=%{v:relnum?v:lnum:v:lnum}%s'

-- Start up neotree when vim starts up
vim.api.nvim_create_autocmd("VimEnter", { callback = function() vim.cmd("Neotree") end, })
