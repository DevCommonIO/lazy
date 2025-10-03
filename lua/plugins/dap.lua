-- File: lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    keys = function(_, keys)
      local dap = require("dap")

      keys = {}

      -- Standard debug controls
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F8>", dap.terminate, { desc = "Debug: Stop" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })

      return keys
    end,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Make the bottom console taller and split REPL/Console 50/50
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 20, -- height in lines (increase/decrease as desired)
            position = "bottom",
          },
          {
            elements = { "scopes", "watches", "breakpoints", "stacks" },
            size = 40, -- width in columns for the left sidebar
            position = "left",
          },
        },
      })

      -- Auto-open UI on session start
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Keep UI open on errors / termination
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- intentionally no close -> UI stays open
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- intentionally no close -> UI stays open
      end
    end,
  },
}
