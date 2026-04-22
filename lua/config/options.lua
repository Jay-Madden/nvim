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

-- Set window border style globally
-- HACK: We want to eventually set this to "rounded" but
-- most plugins dont yet support this options
-- E.G.
-- https://github.com/nvim-telescope/telescope.nvim/issues/3436
-- https://github.com/folke/lazy.nvim/issues/1951
-- So for now we will disable it
vim.o.winborder = "none"

-- sync buffers automatically
vim.opt.autoread = true
-- disable neovim generating a swapfile and showing the error
vim.opt.swapfile = false

-- Default nvim-ufo fold settings
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.g.health = { style = "float" }

-- Only show virtual text for current lines
-- if vim.fn.has("nvim-0.11.0") == 1 then
--   vim.diagnostic.config({
--     virtual_text = { current_line = true, severity = { min = "INFO", max = "ERROR" } },
--     virtual_lines = { current_line = false, severity = { min = "ERROR" } },
--   })
-- end

vim.api.nvim_create_user_command("GitLink", function()
  local origin = vim.fn.system("git config --get remote.origin.url"):gsub("[\n\r]", "")

  local base_url, host, path
  if origin:match("^ssh://git@") then
    -- ssh://git@host:port/path.git
    host, path = origin:match("^ssh://git@([^:/]+)[:%d]*/(.+)$")
    path = path:gsub("%.git$", "")
    base_url = "https://" .. host .. "/" .. path
  elseif origin:match("^git@") then
    -- git@host:org/repo.git
    host, path = origin:match("^git@([^:]+):(.+)$")
    path = path:gsub("%.git$", "")
    base_url = "https://" .. host .. "/" .. path
  else
    host = origin:match("^https?://([^/]+)/")
    base_url = origin:gsub("%.git$", "")
  end

  local is_gitlab = host and host:match("gitlab")
  local blob_prefix = is_gitlab and "/-/blob/" or "/blob/"

  local relative_path = vim.fn.expand("%:.")
  if relative_path == "" or relative_path == "." then
    vim.fn.setreg("+", base_url)
    vim.print(base_url .. " copied to system clipboard")
    return
  end

  local current_rev = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD")
  current_rev = current_rev:gsub("[\n\r]", ""):gsub("^refs/remotes/origin/", "")

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local permalink = base_url .. blob_prefix .. current_rev .. "/" .. relative_path .. "#L" .. row

  vim.fn.setreg("+", permalink)
  vim.print(permalink .. " copied to system clipboard")
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
-- Automatically reload files when they change externally
vim.o.autoread = true
vim.api.nvim_create_autocmd(
  { "BufEnter", "CursorHold", "CursorHoldI", "FocusGained", "TermClose", "TermLeave" },
  {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
  }
)

-- Enable smooth scrolling
vim.opt.smoothscroll = true

-- Treat underscore as a word delimiter
-- E.G makes daw work on _foobar_ properly
vim.opt.iskeyword:remove("_")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Highlight on yank and do not set registers if the yanked text is all whitespace
local prev_unnamed_reg = ""
local prev_plus_reg = ""
local prev_star_reg = ""

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()

    -- Only prevent the whitespace if the unnamed register is used.
    -- If a specific register is used the whitespace was probably intentional
    if vim.v.event.regname == "" then
      local val = vim.fn.getreg('"')

      if val:match("^%s*$") then
        vim.fn.setreg('"', prev_unnamed_reg)
        vim.fn.setreg("+", prev_plus_reg)
        vim.fn.setreg("*", prev_star_reg)
      else
        prev_unnamed_reg = val
        prev_plus_reg = vim.fn.getreg("+")
        prev_star_reg = vim.fn.getreg("*")
      end
    end
  end,
})

-- When nvim is started with piped stdin, try to parse the buffer as YAML
-- and set the filetype accordingly. Requires a meaningful structure (mapping
-- or sequence) so bare text doesn't get misdetected as a YAML scalar.
vim.api.nvim_create_autocmd("StdinReadPost", {
  callback = function(event)
    local buf = event.buf
    if vim.bo[buf].filetype ~= "" then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local content = table.concat(lines, "\n")
    if content:match("^%s*$") then
      return
    end

    if not pcall(vim.treesitter.language.add, "yaml") then
      return
    end

    local ok, parser = pcall(vim.treesitter.get_string_parser, content, "yaml")
    if not ok or not parser then
      return
    end

    local parse_ok, trees = pcall(function()
      return parser:parse()
    end)
    if not parse_ok or not trees or not trees[1] then
      return
    end

    local root = trees[1]:root()
    if root:has_error() then
      return
    end

    local query = vim.treesitter.query.parse(
      "yaml",
      "[(block_mapping) (block_sequence) (flow_mapping) (flow_sequence)] @structure"
    )
    for _ in query:iter_captures(root, content) do
      vim.bo[buf].filetype = "yaml"
      return
    end
  end,
})

-- Go to last loc when opening a buffer
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
