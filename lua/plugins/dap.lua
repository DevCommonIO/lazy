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

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "breakpoints", size = 0.10 },
              { id = "scopes", size = 0.45 },
              { id = "watches", size = 0.35 },
              { id = "stacks", size = 0.10 },
            },
            size = 50, -- width of left sidebar
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.56 }, -- REPL slightly bigger
              { id = "console", size = 0.44 }, -- Console slightly smaller
            },
            size = 14, -- increased height of bottom window
            position = "bottom",
          },
        },
      })

      -- Auto-open UI on session start
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Keep UI open on errors / termination
      dap.listeners.before.event_terminated["dapui_config"] = function() end
      dap.listeners.before.event_exited["dapui_config"] = function() end

      -- Highlight current execution line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3b4252", underline = true })
      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DapStoppedLine",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedLine",
      })
    end,
  },
}
