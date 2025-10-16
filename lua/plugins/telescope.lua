local M = {}

M = {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },

  keys = function()
    local keymaps = {
      -- ##### Temporary fallback binding while we test out snacks pickers #####
      {
        "<leader>ss",
        function()
          M.find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>sg",
        function()
          M.live_grep()
        end,
        desc = "Live grep",
      },
      -- ##########
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() })
        end,
        desc = "Find files in current buffer directory",
      },
      {
        "<Leader>ft",
        function()
          require("telescope.builtin").builtin()
        end,
        desc = "View builtin pickers",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Find references",
      },
      {
        "<leader>fR",
        function()
          require("telescope.builtin").registers()
        end,
        desc = "View registers",
      },
      {
        "<leader>fm",
        function()
          require("telescope.builtin").marks()
        end,
        desc = "View marks",
      },
      {
        "<leader>fj",
        function()
          -- Modified from here https://github.com/nvim-telescope/telescope.nvim/blob/a4ed82509cecc56df1c7138920a1aeaf246c0ac5/lua/telescope/builtin/__internal.lua#L1483
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local make_entry = require("telescope.make_entry")

          local jumplist = vim.fn.getjumplist()[1]

          -- reverse the list
          local sorted_jumplist = {}
          for i = #jumplist, 1, -1 do
            if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
              local text = vim.api.nvim_buf_get_lines(
                jumplist[i].bufnr,
                jumplist[i].lnum - 1,
                jumplist[i].lnum,
                false
              )[1] or ""
              jumplist[i].text = text

              local name = vim.api.nvim_buf_get_name(jumplist[i].bufnr)

              if not name:find(vim.fn.getcwd(), 1, false) then
                table.insert(sorted_jumplist, jumplist[i])
              end
            end
          end

          pickers
            .new({}, {
              prompt_title = "Jumplist",
              finder = finders.new_table({
                results = sorted_jumplist,
                entry_maker = make_entry.gen_from_quickfix({}),
              }),
              previewer = conf.qflist_previewer({}),
              sorter = conf.generic_sorter({}),
            })
            :find()
        end,
        desc = "View the jump list",
      },
      {
        "<Leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbol_width = 50,
          })
        end,
        desc = "Find all symbols in the current document",
      },
      {
        "<Leader>fS",
        function()
          require("telescope.builtin").lsp_workspace_symbols({
            symbol_width = 50,
            query = "all",
          })
        end,
        desc = "Find all symbols in the current workspace",
      },
      {
        "<Leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Browse buffers",
      },
      {
        "<Leader>fv",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = "Browse files",
      },
      -- Select directories containing .git in the specified search_dirs.
      {
        "<Leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.env.HOME,
            find_command = {
              "fd",
              "--prune",
              "--hidden",
              "--absolute-path",
            },
            file_ignore_patterns = { "%node_modules" },
            attach_mappings = function(prompt_bufnr, _map)
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local dir = action_state.get_selected_entry()[1]

                vim.cmd("Neotree close")

                -- Remove .git from the path so we can open the project root.
                dir = string.gsub(dir, "(.*)/.git", "%1")
                vim.cmd.cd(dir)
              end)
              return true
            end,
            search_file = "^\\.git$",
            search_dirs = { "~/programming", "~/.config" },
          })
        end,
        desc = "Find Projects",
      },
      {
        "<Leader>fT",
        function()
          if vim.bo.filetype ~= "go" then
            vim.notify("Can not find ginkgo tests in non go file")
            return
          end

          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local original_buffer = vim.api.nvim_win_get_buf(0)

          local dap = require("plugins.dap")

          local all_tests = dap.query_current_file_ginkgo_tests("test_name")

          if #all_tests == 0 then
            vim.notify("No matching ginkgo nodes found")
            return
          end

          pickers
            .new({}, {
              prompt_title = "Debug tests",
              finder = finders.new_table({
                results = all_tests,
                entry_maker = function(entry)
                  return {
                    value = entry,
                    display = entry[1],
                    ordinal = entry[1],
                  }
                end,
              }),
              attach_mappings = function()
                actions.select_default:replace(function(bufnr)
                  local selected_entry = action_state.get_selected_entry()

                  dap.debug_ginkgo_test(
                    original_buffer,
                    selected_entry.value[2],
                    selected_entry.value[3]
                  )
                  actions.close(bufnr)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = "Debug ginkgo tests",
      },
      {
        "<Leader>fw",
        function()
          local trouble_telescope = require("trouble.sources.telescope")
          trouble_telescope.open()
        end,
      },
    }

    -- Generate keymaps for opening a telescope picker that selects all files in
    -- N number of parent directories
    for i = 1, 9 do
      local backward_dir_nav = ""
      for _ = 1, i do
        backward_dir_nav = backward_dir_nav .. "/.."
      end

      local keymap = {
        "<leader>f" .. i,
        function()
          require("telescope.builtin").find_files({
            cwd = require("telescope.utils").buffer_dir() .. backward_dir_nav,
          })
        end,
        desc = "Find files in buffer directory with " .. i .. " parent directories included",
      }
      table.insert(keymaps, keymap)
    end

    return keymaps
  end,

  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
    })
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("fzf")
  end,
}

--- Find files using fd, excluding .git and vendor directories.
function M.find_files()
  local fd_cmd = {
    "fd",
    "--type",
    "f",
    "--color",
    "never",
    "--hidden",
    "--exclude",
    ".git",
    "--exclude",
    "vendor/",
  }
  require("telescope.builtin").find_files({ find_command = fd_cmd })
end

--- Live grep using ripgrep, excluding .git and vendor directories.
function M.live_grep()
  require("telescope.builtin").live_grep({
    glob_pattern = { "!.git/*", "!vendor/*" },
  })
end

return M
