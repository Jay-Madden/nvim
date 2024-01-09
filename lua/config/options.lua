-- Turn on line numbers, duh
vim.opt.number = true

-- Map the leader for various ide commands
vim.g.mapleader = ";"

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Show the gitsigns status to the right of the numbers instead of to the left
-- vim.opt.statuscolumn = '%=%{v:relnum?v:lnum:v:lnum}%s'

-- Start up neotree when vim starts up
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  callback = function()
		vim.cmd("Neotree")
  end,
})
