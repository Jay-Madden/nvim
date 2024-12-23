return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },

  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
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
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<Leader>fs",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbol_width = 50,
        })
      end,
      desc = "Find all symbols in current document",
    },
    {
      "<Leader>fS",
      function()
        require("telescope.builtin").lsp_workspace_symbols({
          symbol_width = 50,
          query = "all",
        })
      end,
      desc = "Find all symbols in current document",
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
      "<Leader>ft",
      function()
        local harpoon = require("harpoon")
        local harpoon_files = harpoon:list()
        local conf = require("telescope.config").values

        local file_paths = {}
        for idx, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, { idx, item.value })
        end
        local picker = require("telescope.pickers")
        picker
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = "[" .. entry[1] .. "] " .. entry[2],
                  ordinal = entry[2],
                }
              end,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end,
      desc = "Browse harpoon marks",
    },
    {
      "<Leader>fw",
      function()
        local trouble_telescope = require("trouble.sources.telescope")
        trouble_telescope.open()
      end,
    },
  },

  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    require("telescope").load_extension("ui-select")
  end,
}
