return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-symbols.nvim",
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
      "<Leader>fs",
      function()
        local trouble_telescope = require("trouble.sources.telescope")
        trouble_telescope.open()
      end,
    }
  },

  config = function()
    require("telescope").setup({})
  end,
}
