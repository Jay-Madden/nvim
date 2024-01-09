return {
	"mfussenegger/nvim-dap",
 	event = "VeryLazy",

  dependencies = {
    "rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
  },

	config = function(_, opts)
		local dap = require("dap")
    local dapui = require("dapui")
		local neotree = require("neo-tree")

		require('dap-go').setup()

		dapui.setup(opts)

		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

		-- Configure the dap event handlers
		-- make sure we close neotree before we start debugging as neotree takes up 
		-- screen space
		dap.listeners.after.event_initialized["dapui_config"] = function()
			neotree.close_all()
			dapui.open()
		end

		-- Reopen neotree when debugger ui exits
    dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
			vim.cmd("Neotree")
		end

    dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
			vim.cmd("Neotree")
		end
		----

		require('dap-go').setup {
			-- Additional dap configurations can be added.
			-- dap_configurations accepts a list of tables where each entry
			-- represents a dap configuration. For more details do:
			-- :help dap-configuration
			dap_configurations = {
				{
					-- Must be "go" or it will be ignored by the plugin
					type = "go",
					name = "Debug Operator",
					request = "launch",
					program = "./cmd/main.go"
				},
			},
			-- delve configurations
			delve = {
				-- the path to the executable dlv which will be used for debugging.
				-- by default, this is the "dlv" executable on your PATH.
				path = "dlv",
				-- time to wait for delve to initialize the debug session.
				-- default to 20 seconds
				initialize_timeout_sec = 20,
				-- a string that defines the port to start delve debugger.
				-- default to string "${port}" which instructs nvim-dap
				-- to start the process in a random available port
				port = "${port}",
				-- additional args to pass to dlv
				args = {},
				-- the build flags that are passed to delve.
				-- defaults to empty string, but can be used to provide flags
				-- such as "-tags=unit" to make sure the test suite is
				-- compiled during debugging, for example.
				-- passing build flags using args is ineffective, as those are
				-- ignored by delve in dap mode.
				build_flags = "",
			},
		}
	end,

}
