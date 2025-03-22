return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap-python", -- Optional for Python debugging
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Setup DAP UI
        dapui.setup()

        -- Auto-open/close UI on debugging events
        dap.listeners.before.attach.dapui = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui = function()
            dapui.close()
        end

        -- Keymaps for debugging
        vim.keymap.set("n", "<leader>tg", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<leader>gt", dap.continue, {})
        vim.keymap.set("n", "<leader>ge", dap.step_over, {})
        vim.keymap.set("n", "<leader>gi", dap.step_into, {})
        vim.keymap.set("n", "<leader>go", dap.step_out, {})
        vim.keymap.set("n", "<leader>g'", function()
            require("dap").disconnect({ terminateDebuggee = true })
            require("dapui").close() -- Ensure UI closes too
        end, {})

        -- GDB Debugger Adapter
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" }, -- Use "dap" mode for compatibility with nvim-dap
        }

        -- C / C++ / Rust Debugging Configurations
        dap.configurations.cpp = {
            {
                name = "Launch with GDB",
                type = "gdb",
                request = "launch",
                program = function()
                    -- Automatically find the most recent executable in the build folder
                    local handle = io.popen("ls -t build/* | head -1") -- Adjust "build/*" to match your binary location
                    local result = handle:read("*a")
                    handle:close()
                    return result:gsub("\n", "") -- Remove newline from output
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
    end,
}
