-- Turn on line numbers, duh
vim.opt.number = true

-- Map the leader for various ide commands
vim.g.mapleader = ";"

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Work with system clipboard
vim.opt.clipboard = "unnamedplus"  -- Insert indents automatically
-- Indent smartly
vim.opt.smartindent = true
-- Put new windows right of current
vim.opt.splitright = true
-- Allow cursor to move in virtual space in block mode
vim.opt.virtualedit = "block"
-- Always show the signcolumn so we dont shift text every time
vim.opt.signcolumn = "yes"
-- Make the status line global for all windows
vim.opt.laststatus = 3
-- Command-line completion mode
vim.opt.wildmode = "longest:full,full"

-- Enable smooth scrolling
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
end

-- Start up neotree when vim starts up
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  callback = function()
		vim.cmd("Neotree")
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
