local utils = require("utils")

return {
  keys = function()
    local keymaps = {
      {
        "<leader>ff",
        function()
          Snacks.picker.smart({
            multi = { "files" },
            hidden = true,
            ignore = true,
          })
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep({
            hidden = true,
          })
        end,
        desc = "Live grep",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.pick()
        end,
        desc = "Snacks Pickers",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "Command History",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Command History",
      },
      {
        "<leader>fS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Command History",
      },
    }

    -- Generate keymaps for opening a snacks picker that selects all files in
    -- the current directory + N number of parent directories
    for i = 0, 5 do
      local backward_dir_nav = ""
      for _ = 1, i do
        backward_dir_nav = backward_dir_nav .. "/.."
      end

      local keymap = {
        "<leader>f" .. i,
        function()
          Snacks.picker.smart({
            multi = { "files" },
            cwd = utils.buffer_dir() .. backward_dir_nav,
            hidden = true,
            ignore = true,
          })
        end,
        desc = i == 0 and "Find files in current directory"
          or ("Find files in buffer directory with " .. i .. " parent directories included"),
      }
      table.insert(keymaps, keymap)
    end

    return keymaps
  end,
  opts = {
    picker = {
      exclude = {
        ".git",
        "node_modules",
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 80,
        },
      },
      -- More custom telescope like layout, to be used if we can not get used to the top bar layout
      --   layout = {
      --     reverse = true,
      --     layout = {
      --       box = "horizontal",
      --       width = 0.8,
      --       min_width = 120,
      --       height = 0.85,
      --       {
      --         box = "vertical",
      --         border = "rounded",
      --         title = "{title} {live} {flags}",
      --         { win = "list", border = "none" },
      --         { win = "input", height = 1, border = "top" },
      --       },
      --       { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
      --     },
      --   },
    },
  },
}
