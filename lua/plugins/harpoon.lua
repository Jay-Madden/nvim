local utils = require("utils")

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    utils.map("n", "<leader>ha", function()
      local curr_buf = vim.api.nvim_buf_get_name(0)
      harpoon:list():append(curr_buf)
      vim.notify_once("Harpoon mark for buffer " .. curr_buf .. " added", vim.log.levels.INFO)
    end, { desc = "Add harpoon mark" })

    utils.map("n", "<leader>hr", function()
      local curr_buf = vim.api.nvim_buf_get_name(0)
      harpoon:list():remove(curr_buf)
      vim.notify_once("Harpoon mark for buffer " .. curr_buf .. " removed", vim.log.levels.INFO)
    end, { desc = "Remove harpoon mark" })

    utils.map("n", "<leader>hn", function()
      harpoon:list():next()
    end, { desc = "Go to next harpoon mark" })
    utils.map("n", "<leader>hp", function()
      harpoon:list():prev()
    end, { desc = "Go to previous harpoon mark" })
  end,
}
