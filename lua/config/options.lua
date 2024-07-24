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

local function wrap_golang_multi_return(args)
  -- If its not a go buffer dont bother doing any more work
  if vim.bo.filetype ~= "go" then
    return
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num, line_col = cursor_pos[1], cursor_pos[2]
  local curr_buf = vim.api.nvim_get_current_buf()

  local line = vim.api.nvim_buf_get_lines(curr_buf, line_num - 1, line_num, false)[1]

  local P, R, S, C, Cs = vim.lpeg.P, vim.lpeg.R, vim.lpeg.S, vim.lpeg.C, vim.lpeg.Cs

  local letter = R("az", "AZ") + S("_")
  local digit = R("09")

  local whitespace = S(" \t\n")
  local repeat_whitespace = whitespace ^ 0

  local alphanumeric = letter + digit
  local identifier = alphanumeric ^ 1
  local symbol = S("., &*-[]|")

  local open_paren = P("(")
  local close_paren = P(")")
  local open_bracket = P("[")
  local close_bracket = P("]")
  local open_brace = P("{")
  local close_brace = P("}")

  local func_keyword = P("func")

  local arguments = alphanumeric + symbol + whitespace

  local function_argument_list = open_paren * arguments ^ 0 * close_paren

  -- We are just gonna ignore that nested generics happen
  local generic_argument_list = open_bracket * (arguments - close_bracket) ^ 0 * close_bracket

  local reciever = open_paren
    * alphanumeric ^ 1
    * repeat_whitespace
    * P("*") ^ -1
    * identifier
    * repeat_whitespace
    * close_paren
  --
  -- The signature can be malformed, in fact it likely as this happens while we are typing
  local return_signature = open_paren ^ 0 * (identifier + symbol) ^ 1 * close_paren ^ 0

  local return_signature_capture = vim.lpeg.Cs((return_signature / function(match)
    if match == nil then
      return
    end

    local function gsub(s, patt, repl)
      patt = vim.lpeg.P(patt)
      patt = vim.lpeg.Cs((patt / repl + 1) ^ 0)
      return vim.lpeg.match(patt, s)
    end

    -- Strip the parens off, we will add them back if we need to
    local value = gsub(match, "(", "")
    value = gsub(value, ")", "")

    -- Disable the type error, lpeg match will work as a string
    ---@diagnostic disable-next-line: param-type-mismatch
    local returns = vim.split(value, ",")
    if #returns == 1 then
      line_col = line_col - 1
      return value
    else
      line_col = line_col + 1
      return "(" .. value .. ")"
    end
  end))

  local anonymous_function = C(func_keyword * function_argument_list * repeat_whitespace)
    * return_signature_capture * C(repeat_whitespace * open_brace ^ 0 * repeat_whitespace)
  local named_function = C(
    func_keyword
      * repeat_whitespace
      * reciever ^ 0
      * repeat_whitespace
      * identifier
      * generic_argument_list ^ 0
      * repeat_whitespace
      * function_argument_list
      * repeat_whitespace
  ) * return_signature_capture * C(repeat_whitespace * open_brace ^ 0 * repeat_whitespace)
  local full_function = anonymous_function + named_function

  -- We want to ignore the start of the line incase it is a lambda
  local full_line = Cs(((P(1) - func_keyword) ^ 0 * full_function))

  local match = vim.lpeg.match(full_line, line)

  if match == nil then
    return
  end

  -- Disable the type error, lpeg match will work as a string
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_set_current_line(match)

  -- When we add parenthesis we need to bump the cursor one block to the right to account for the paren on the left.
  -- we bump the column number in the match handler and execute it here
  vim.api.nvim_win_set_cursor(0, { line_num, line_col })
end

-- func foo() (error,)
-- func foo() err
-- func shouldCreateHpaReplicas(region string, webapp v1alpha1.WebApp) bool {

vim.api.nvim_create_autocmd(
  { "TextChanged", "TextChangedI" },
  { callback = wrap_golang_multi_return }
)
-- vim.api.nvim_create_user_command("TestG", wrap_golang_multi_return, {nargs="?"})

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
