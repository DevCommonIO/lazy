-- File: lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python", -- ✅ Python adapter helper
      "nvim-neotest/nvim-nio", -- ✅ required by dap-ui in many setups
    },

    keys = function(_, keys)
      local dap = require("dap")

      keys = {}

      -- Auto-scroll DAP REPL to bottom on new output
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "DAP REPL",
        callback = function(args)
          local bufnr = args.buf
          vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
              vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(bufnr), 0 })
            end,
          })
        end,
      })

      vim.keymap.set({ "n", "i", "t" }, "<F8>", function()
        local dap = require("dap")

        -- If pressed from terminal-mode (DAP console), exit terminal-mode first
        if vim.fn.mode() == "t" then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
        end

        -- Stop session (terminate is usually enough; disconnect/close are fine too)
        dap.terminate()
        dap.disconnect()
        dap.close()
      end, { desc = "Debug: Stop", silent = true })

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })

      -- ✅ Python test helpers (optional but super useful)
      vim.keymap.set("n", "<leader>dtm", function()
        require("dap-python").test_method()
      end, { desc = "Debug: Python test (method)" })

      vim.keymap.set("n", "<leader>dtc", function()
        require("dap-python").test_class()
      end, { desc = "Debug: Python test (class)" })

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
            size = 50,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.56 },
              { id = "console", size = 0.44 },
            },
            size = 14,
            position = "bottom",
          },
        },
      })

      -- ✅ Use Mason-installed debugpy (recommended)
      -- Ensure :Mason -> install "debugpy"
      local mason_dbgpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

      -- ✅ Prefer project venv if present
      local function python_from_venv()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and #venv > 0 then
          return venv .. "/bin/python"
        end

        -- common local venv folders
        local cwd = vim.fn.getcwd()
        local candidates = {
          cwd .. "/.venv/bin/python",
          cwd .. "/venv/bin/python",
          cwd .. "/.env/bin/python",
        }
        for _, p in ipairs(candidates) do
          if vim.fn.executable(p) == 1 then
            return p
          end
        end

        return mason_dbgpy
      end

      -- ✅ Setup dap-python (registers debugpy adapter)
      require("dap-python").setup(mason_dbgpy)
      require("dap-python").test_runner = "pytest" -- optional

      -- ✅ Python configurations (launch current file)
      dap.configurations.python = {
        {
          type = "python", -- dap-python registers adapter as "python"
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = python_from_venv,
          console = "integratedTerminal",
          justMyCode = true,
        },
      }

      -- Auto-open UI on session start
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Keep UI open on errors / termination (as you wanted)
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
