local M = {}
local namespace = vim.api.nvim_create_namespace("NoIndexDiff")
local comment_namespace = vim.api.nvim_create_namespace("NoIndexDiffComments")

---@class DiffWordChange
---@field start integer
---@field word string

---@class DiffAddedLine
---@field line_number integer
---@field text string
---@field word_changes DiffWordChange[]

---@class DiffHunk
---@field old_start integer
---@field old_count integer
---@field new_start integer
---@field new_count integer
---@field deleted string[]
---@field added DiffAddedLine[]
---@field line_changes? integer[][]

---@param output string
---@return DiffHunk[]
local function parse_hunks(output)
  ---@type DiffHunk[]
  local hunks = {}
  ---@type DiffHunk?
  local hunk
  ---@type integer?
  local next_new_line

  for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
    local old_start, old_count, new_start, new_count = line:match("^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@")

    if old_start then
      hunk = {
        old_start = tonumber(old_start),
        old_count = tonumber(old_count) or 1,
        new_start = tonumber(new_start),
        new_count = tonumber(new_count) or 1,
        deleted = {},
        added = {},
      }
      next_new_line = hunk.new_start
      table.insert(hunks, hunk)
    elseif hunk then
      local prefix = line:sub(1, 1)

      if prefix == "-" then
        table.insert(hunk.deleted, line:sub(2))
      elseif prefix == "+" then
        table.insert(hunk.added, {
          line_number = next_new_line,
          text = line:sub(2),
          word_changes = {},
        })
        next_new_line = next_new_line + 1
      elseif prefix == " " then
        next_new_line = next_new_line + 1
      end
    end
  end

  return hunks
end

local function align_hunk(hunk)
  local added_text = {}
  for index, added_line in ipairs(hunk.added) do
    added_text[index] = added_line.text
  end

  return vim.text.diff(table.concat(hunk.deleted, "\n"), table.concat(added_text, "\n"), {
    algorithm = "histogram",
    linematch = 60,
    result_type = "indices",
  })
end

local function word_wrap(text, limit)
  local lines = {}
  local line = ""

  for word in text:gmatch("%S+") do
    local candidate = line == "" and word or line .. " " .. word
    if line ~= "" and vim.fn.strdisplaywidth(candidate) > limit then
      table.insert(lines, line)
      line = word
    else
      line = candidate
    end
  end

  if line ~= "" then
    table.insert(lines, line)
  end

  return lines
end

local function render_comments(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, comment_namespace, 0, -1)

  local comments = vim.b[bufnr].no_index_diff_comments or {}
  local added_lines = vim.b[bufnr].no_index_diff_added_lines or {}
  for line_number, text in pairs(comments) do
    if added_lines[line_number] and text ~= vim.NIL then
      local horizontal = vim.fn.nr2char(0x2500)
      local vertical = vim.fn.nr2char(0x2502)
      local winid = vim.fn.bufwinid(bufnr)
      local wininfo = vim.fn.getwininfo(winid)[1]
      local width = vim.api.nvim_win_get_width(winid) - wininfo.textoff
      local content_width = math.min(width - 4, math.max(math.floor(width / 2) - 4, vim.fn.strdisplaywidth(text)))
      local box_lines = {
        { { vim.fn.nr2char(0x256D) .. string.rep(horizontal, content_width + 2) .. vim.fn.nr2char(0x256E), "DiffAdd" } },
      }
      for _, line in ipairs(word_wrap(text, content_width)) do
        local padding = string.rep(" ", math.max(content_width - vim.fn.strdisplaywidth(line), 0))
        table.insert(box_lines, { { vertical .. " " .. line .. padding .. " " .. vertical, "DiffAdd" } })
      end
      table.insert(box_lines, {
        { vim.fn.nr2char(0x2570) .. string.rep(horizontal, content_width + 2) .. vim.fn.nr2char(0x256F), "DiffAdd" },
      })

      vim.api.nvim_buf_set_extmark(bufnr, comment_namespace, line_number - 1, 0, {
        virt_lines = box_lines,
        priority = 202,
      })
    end
  end
end

local function write_comments()
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    return
  end

  local comments = {}
  for line_number, text in pairs(vim.b[bufnr].no_index_diff_comments or {}) do
    if type(text) == "string" then
      table.insert(comments, {
        suggested_change = vim.api.nvim_buf_get_lines(bufnr, tonumber(line_number) - 1, tonumber(line_number), false)[1],
        line = tonumber(line_number),
        comment = text,
      })
    end
  end
  table.sort(comments, function(left, right)
    return left.line < right.line
  end)

  if #comments == 0 then
    vim.notify("No diff comments to write for " .. file, vim.log.levels.INFO)
    return
  end

  local lines = {}
  for _, comment in ipairs(comments) do
    table.insert(lines, vim.json.encode(comment))
  end

  local output_file = vim.b[bufnr].no_index_diff_comments_file
  if type(output_file) ~= "string" then
    output_file = vim.fn.fnamemodify(file, ":h") .. "/.diff-comments.jsonl"
  end
  vim.fn.writefile(lines, output_file)
end

local function render_hunks(bufnr, hunks)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for _, hunk in ipairs(hunks) do
    local row = math.min(math.max(hunk.new_start - 1, 0), line_count - 1)
    local extmark = { priority = 200 }

    if #hunk.deleted > 0 then
      local virtual_lines = {}
      for _, line in ipairs(hunk.deleted) do
        -- Show a single space for whitespace removals
        table.insert(virtual_lines, { { line == "" and " " or line, "DiffDelete" } })
      end

      extmark.virt_lines = virtual_lines
      extmark.virt_lines_above = hunk.new_start <= line_count
    end

    if #hunk.added > 0 then
      extmark.end_row = hunk.added[#hunk.added].line_number
      extmark.end_col = 0
      extmark.hl_eol = true
      extmark.hl_group = "DiffAdd"
    end

    vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, extmark)

    for _, added_line in ipairs(hunk.added) do
      for _, word_change in ipairs(added_line.word_changes) do
        vim.api.nvim_buf_set_extmark(bufnr, namespace, added_line.line_number - 1, word_change.start - 1, {
          end_col = word_change.start - 1 + #word_change.word,
          hl_group = "DiffText",
          priority = 201,
        })
      end
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("NoIndexDiffResize", { clear = true })
  vim.api.nvim_create_autocmd("WinResized", {
    group = group,
    callback = function()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.bufwinid(bufnr) ~= -1 and vim.b[bufnr].no_index_diff_comments then
          render_comments(bufnr)
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = write_comments,
  })

  function M.diff(previous_file, comments_file)
    if type(previous_file) ~= "string" or previous_file == "" then
      vim.notify("Diff requires a previous file", vim.log.levels.ERROR)
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(bufnr)
    if current_file == "" then
      vim.notify("Diff requires the current buffer to have a file name", vim.log.levels.ERROR)
      return
    end

    local output_file = comments_file
    if output_file then
      output_file = vim.fn.fnamemodify(vim.fn.expand(output_file), ":p")
    else
      output_file = vim.fn.fnamemodify(current_file, ":h") .. "/.diff-comments.jsonl"
    end
    vim.b[bufnr].no_index_diff_comments_file = output_file

    vim.system({ "git", "diff", "--no-index", "--unified=0", "--", previous_file, current_file }, { text = true }, vim.schedule_wrap(function(result)
      if result.code ~= 0 and result.code ~= 1 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return
      end

      local hunks = parse_hunks(result.stdout)
      for _, hunk in ipairs(hunks) do
        hunk.line_changes = align_hunk(hunk)
      end

      for _, hunk in ipairs(hunks) do
        for _, change in ipairs(hunk.line_changes) do
          local old_start, old_count, new_start, new_count = unpack(change)
          if old_count > 0 and new_count > 0 and old_count == new_count then
            for offset = 0, old_count - 1 do
              local old_line = hunk.deleted[old_start + offset]
              local new_line = hunk.added[new_start + offset]

              local old_line_words = {}
              for start, word in old_line:gmatch("()(%S+)") do
                table.insert(old_line_words, { start = start, word = word })
              end

              local new_line_words = {}
              for start, word in new_line.text:gmatch("()(%S+)") do
                table.insert(new_line_words, { start = start, word = word })
              end

              -- calculate the word diffs for simple line changes
              local word_hunks = vim.text.diff(
                table.concat(vim.tbl_map(function(w) return w.word end, old_line_words), "\n"),
                table.concat(vim.tbl_map(function(w) return w.word end, new_line_words), "\n"),
                {
                  algorithm = "minimal",
                  result_type = "indices",
                }
              )
              for _, word_change in ipairs(word_hunks) do
                local _, old_word_count, new_word_start, new_word_count = unpack(word_change)
                if old_word_count > 0 and new_word_count > 0 then
                  for word_offset = 0, new_word_count - 1 do
                    local new_word = new_line_words[new_word_start + word_offset]
                    table.insert(new_line.word_changes, new_word)
                  end
                end
              end
            end
          end
        end
      end

      local added_lines = {}
      for _, hunk in ipairs(hunks) do
        for _, added_line in ipairs(hunk.added) do
          added_lines[added_line.line_number] = true
        end
      end
      vim.b[bufnr].no_index_diff_added_lines = added_lines

      render_hunks(bufnr, hunks)
      render_comments(bufnr)

      local first_hunk = hunks[1]
      if first_hunk then
        local added_line = first_hunk.added[1]
        local line_number = added_line and added_line.line_number or first_hunk.new_start
        line_number = math.min(math.max(line_number, 1), vim.api.nvim_buf_line_count(bufnr))

        local winid = vim.fn.bufwinid(bufnr)
        if winid ~= -1 then
          vim.api.nvim_win_set_cursor(winid, { line_number, 0 })
          vim.api.nvim_win_call(winid, function()
            vim.cmd("normal! zz")
          end)
        end
      end
    end))
  end

  vim.api.nvim_create_user_command("Diff", function(opts)
    if #opts.fargs > 2 then
      vim.notify("Diff accepts a previous file and optional comments file", vim.log.levels.ERROR)
      return
    end
    M.diff(opts.fargs[1], opts.fargs[2])
  end, {
    nargs = "+",
    complete = "file",
    force = true,
  })

  function M.add_comment(text)
    local bufnr = vim.api.nvim_get_current_buf()
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    local added_lines = vim.b[bufnr].no_index_diff_added_lines or {}
    if not added_lines[line_number] then
      vim.notify("DiffComment requires the cursor on an added line", vim.log.levels.ERROR)
      return
    end

    local comments = vim.b[bufnr].no_index_diff_comments or {}
    comments[line_number] = text
    vim.b[bufnr].no_index_diff_comments = comments
    render_comments(bufnr)
  end

  vim.api.nvim_create_user_command("DiffComment", function(opts)
    M.add_comment(opts.args)
  end, {
    nargs = "+",
    force = true,
  })

  function M.delete_comment()
    local bufnr = vim.api.nvim_get_current_buf()
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    local comments = vim.b[bufnr].no_index_diff_comments or {}
    if comments[line_number] == nil or comments[line_number] == vim.NIL then
      vim.notify("No diff comment on the current line", vim.log.levels.ERROR)
      return
    end

    comments[line_number] = nil
    vim.b[bufnr].no_index_diff_comments = comments
    render_comments(bufnr)
  end

  vim.api.nvim_create_user_command("DiffCommentDelete", function()
    M.delete_comment()
  end, {
    nargs = 0,
    force = true,
  })
end

return M
