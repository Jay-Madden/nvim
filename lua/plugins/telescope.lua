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
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<Leader>fb",
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
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value )
        end
        local picker = require("telescope.pickers")
        picker
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end,
      desc = "Browse harpoon marks",
    },
  },

  config = function()
    require("telescope").setup({})
  end,
}
