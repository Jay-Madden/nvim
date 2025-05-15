M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },

  keys = {
    {
      "<Leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<Leader>ds",
      function()
        require("dap").continue()
      end,
      desc = "Start Debugging",
    },
    {
      "<Leader>da",
      function()
        require("dapui").eval()
      end,
      desc = "show values under cursor",
    },
    {
      "<Leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "step into function",
    },
    {
      "<leader>dn",
      function()
        require("dap").step_over()
      end,
      desc = "step over to next line",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "step out to calling function",
    },
    {
      "<leader>dq",
      function()
        require("dap").close()
        require("dapui").close()
      end,
      desc = "step the debugger",
    },
    {
      "<leader>dt",
      function()
        local tests = M.query_current_file_ginkgo_tests("body")
        local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))

        for _, v in ipairs(tests) do
          local start_row, end_row = v[2], v[3]
          if cursor_row > start_row and cursor_row < end_row then
            local original_buffer = vim.api.nvim_win_get_buf(0)
            M.debug_ginkgo_test(original_buffer, start_row + 1, start_row + 2)
          end
        end
      end,
      desc = "debug current ginkgo test under cursor",
    },
    {
      "<Leader>dc",
      function()
        require("dapui").close()
      end,
      desc = "Close debugging window",
    },
  },

  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    local neotree = require("neo-tree")

    dapui.setup(opts)

    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
    )

    -- Configure the dap event handlers
    -- make sure we close neotree before we start debugging as neotree takes up
    -- screen space
    dap.listeners.before.attach.dapui_config = function()
      neotree.close_all()
      dapui.open()
    end

    dap.listeners.before.launch.dapui_config = function()
      neotree.close_all()
      dapui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end

    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    local delve = {
      type = "server",
      -- the path to the executable dlv which will be used for debugging.
      -- by default, this is the "dlv" executable on your PATH.
      -- a string that defines the port to start delve debugger.
      -- default to string "${port}" which instructs nvim-dap
      -- to start the process in a random available port
      port = "${port}",
      options = {
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
      },
      executable = {
        command = "dlv",
        -- additional args to pass to dlv
        args = {},
        -- Automatically handle the issue on delve Windows versions < 1.24.0
        -- where delve needs to be run in attched mode or it will fail (actually crashes).
        detached = vim.fn.has("win32") == 0,
        cwd = nil,
      },
      -- the build flags that are passed to delve.
      -- defaults to empty string, but can be used to provide flags
      -- such as "-tags=unit" to make sure the test suite is
      -- compiled during debugging, for example.
      -- passing build flags using args is ineffective, as those are
      -- ignored by delve in dap mode.
      -- build_flags = "",
    }

    dap.adapters.delve = function(callback, client_config)
      callback({
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "dlv",
          args = {
            "dap",
            "-l",
            "127.0.0.1:${port}",
            "--log",
            "--log-output=dap,rpc,verbose",
            "--log-dest=dlv-dap.log",
          },
          detached = vim.fn.has("win32") == 0,
        },
        options = {
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 20,
        },
      })
    end

    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug Operator",
        request = "launch",
        program = "./cmd/main.go",
      },
    }

    -- Setup rust
    -- local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path()
    --   .. "/extension/adapter/codelldb"
    -- dap.adapters.codelldb = {
    --   type = "server",
    --   host = "127.0.0.1",
    --   port = "${port}",
    --   executable = {
    --     command = codelldb_path,
    --     args = { "--port", "${port}" },
    --   },
    -- }

    -- dap.configurations.rust = {
    --   {
    --     name = "Debug with codelldb",
    --     type = "codelldb",
    --     request = "launch",
    --     program = function()
    --       return vim.fn.input({
    --         prompt = "Path to executable: ",
    --         default = vim.fn.getcwd() .. "/",
    --         completion = "file",
    --       })
    --     end,
    --     cwd = "${workspaceFolder}",
    --     stopOnEntry = false,
    --   },
    -- }
  end,
}

M.query_current_file_ginkgo_tests = function(match_name)
  local test_query = [[
  (call_expression
    function: (identifier) @name
    arguments: (argument_list
    (interpreted_string_literal 
      (interpreted_string_literal_content) @test_name)
    ) 
    (#match? @name"When")
  ) @body
  ]]

  local tree = vim.treesitter.get_parser():parse()[1]

  local query = vim.treesitter.query.parse("go", test_query)

  local all_tests = {}
  for id, node in query:iter_captures(tree:root(), 0) do
    local capture = query.captures[id]

    if capture == match_name then
      local start_row, _, end_row, _ = node:range()
      local name = vim.treesitter.get_node_text(node, 0)
      table.insert(all_tests, { name, start_row, end_row })
    end
  end

  return all_tests
end

M.debug_ginkgo_test = function(buffer_name, start_row, end_row)
  local dap = require("dap")

  local original_filename = vim.fs.basename(vim.api.nvim_buf_get_name(buffer_name))

  -- pass the current test file name and the offset of the treesitter query lines
  -- We add 1 and 2 respectively because treesitter parses the token for function_declaration to be the line ABOVE
  -- where it actually is in the file
  local ginkgo_test_filter = original_filename .. ":" .. start_row + 1 .. "-" .. end_row + 2

  local test_config = {
    type = "delve",
    name = "Debug Operator Test",
    request = "launch",
    mode = "test",
    program = "./internal/controller",
    args = { "--ginkgo.focus-file", ginkgo_test_filter },
  }

  vim.notify("Executing debug config with args")
  dap.run(test_config)
end

return M
