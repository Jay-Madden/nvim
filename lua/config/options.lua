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

-- Default nvim-ufo fold settings
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local function wrap_golang_return()
  if vim.bo.filetype ~= "go" then
    return
  end

  local query_str = [[
    (_
       result: (_) @result 
       (ERROR)? @error 
    ) 
  ]]

  local query = vim.treesitter.query.parse("go", query_str)
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  local tree = vim.treesitter.get_node():tree()

  local final_start_row, final_start_col, final_end_row, final_end_col = 0, 0, 0, 0

  for id, node, _, _ in query:iter_captures(tree:root(), 0) do
    local start_row, _, end_row, end_col = node:range()

    if cursor_row < start_row + 1 or cursor_row > end_row + 1 then
      goto continue
    end

    local capture_name = query.captures[id]
    if capture_name == "result" then
      final_start_row, final_start_col, final_end_row, final_end_col = node:range()
    end
    if capture_name == "error" then
      final_end_col = end_col
      final_end_row = end_row
    end

    ::continue::
  end

  local line = vim.api.nvim_buf_get_text(
    0,
    final_start_row,
    final_start_col,
    final_end_row,
    final_end_col,
    {}
  )[1]
  if line == "" then
    return
  end

  -- Here we rebuild the entire return statement to a syntactically correct version
  -- splitting on commas to decide if there is a parameter list or a single value
  -- Strip the parens off, we will add them back if we need to
  local value = string.gsub(line, "%(", "")
  value = string.gsub(value, "%)", "")

  -- We will need to move the cursor depending on the action that we take,
  -- grab the current cusor position so we can adjust it below
  local final_cursor_col = cursor_col

  local returns = vim.split(value, ",")
  local new_line = line
  if #returns == 1 then
    final_cursor_col = final_cursor_col - 1
    new_line = value
  else
    final_cursor_col = final_cursor_col + 1
    new_line = "(" .. value .. ")"
  end

  -- If the line hasnt changed or theres nothing to add then we just bail out here
  if line == new_line then
    return
  end

  vim.api.nvim_buf_set_text(
    0,
    final_start_row,
    final_start_col,
    final_end_row,
    final_end_col,
    { new_line }
  )
  vim.api.nvim_win_set_cursor(0, { final_end_row + 1, final_cursor_col })
end

vim.api.nvim_create_autocmd(
  -- { "InsertLeave", "TextChanged" },
  { "TextChangedI", "TextChanged" },
  { callback = wrap_golang_return }
)

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
