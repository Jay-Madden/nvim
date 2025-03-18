-- Turn on line numbers, duh
vim.opt.number = true

-- Map the leader for various ide commands
vim.g.mapleader = ";"

vim.opt.termguicolors = true

-- Work with system clipboard
vim.opt.clipboard = "unnamedplus" -- Insert indents automatically
-- Indent smartly
vim.opt.smartindent = true
-- Put new windows right of current
vim.opt.splitright = true
-- Show tabs as 4 spaces
vim.opt.tabstop = 4
-- Set shiftwidth
vim.o.shiftwidth = 4
-- Allow cursor to move in virtual space in block mode
vim.opt.virtualedit = "block"
-- Always show the signcolumn so we dont shift text every time
vim.opt.signcolumn = "yes"
-- Make the status line global for all windows
vim.opt.laststatus = 3
-- Command-line completion mode
vim.opt.wildmode = "longest:full,full"
-- Enable cursor line
vim.opt.cursorline = true
vim.o.cursorlineopt = "both"

-- sync buffers automatically
vim.opt.autoread = true
-- disable neovim generating a swapfile and showing the error
vim.opt.swapfile = false

-- Default nvim-ufo fold settings
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

-- TODO: make this an actual plugin or something
vim.api.nvim_create_user_command("GhLink", function()
  local origin = vim.fn.system("git config --get remote.origin.url")
  origin = origin:gsub("[\n\r]", "")

  local current_rev = vim.fn.system("git rev-parse main")
  current_rev = current_rev:gsub("[\n\r]", "")

  local relative_path = vim.fn.expand("%:.")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local gh_permalink = origin .. "/blob/" .. current_rev .. "/" .. relative_path .. "#L" .. row

  vim.fn.setreg("+", gh_permalink)
  vim.print(gh_permalink .. " copied to system clipboard")
end, {})

-- Neovide configuration options
if vim.g.neovide then
  -- Disable the annoying cursor jump animations when jumping around
  vim.g.neovide_cursor_animation_length = 0

  -- Make the smooth scrolling faster
  vim.g.neovide_scroll_animation_length = 0.2

  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.experimental_layer_grouping = false

  -- When launched from iterm neovide does not focus
  vim.defer_fn(function()
    vim.cmd("NeovideFocus")
  end, 20)
end

-- Add # as the comment string for terraform files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})
-- Automatically reload files when then change externally
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Enable smooth scrolling
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

if vim.fn.has("nvim-0.9.0") == 1 then
  --vim.opt.statuscolumn = [[%!v:lua.require'utils'.statuscolumn()]]
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
