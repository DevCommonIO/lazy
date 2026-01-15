-- File: lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
    },

    keys = function()
      local dap = require("dap")
      local dapui_ok, dapui = pcall(require, "dapui")

      -- Clean up all debug output when a session ends
      local function clean_debug_views()
        pcall(dap.repl.clear) -- clears REPL buffer
        pcall(dapui.close) -- closes dap-ui windows (repl, console, scopes, etc)
      end

      dap.listeners.before.event_terminated["clean_on_stop"] = clean_debug_views
      dap.listeners.before.event_exited["clean_on_stop"] = clean_debug_views

      return {
        { "<F5>", dap.continue, desc = "Debug: Start/Continue" },
        { "<F10>", dap.step_over, desc = "Debug: Step Over" },
        { "<F11>", dap.step_into, desc = "Debug: Step Into" },
        { "<F12>", dap.step_out, desc = "Debug: Step Out" },

        { "<leader>db", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
        {
          "<leader>dB",
          function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Debug: Conditional Breakpoint",
        },
        { "<leader>dr", dap.repl.open, desc = "Debug: Open REPL" },
        { "<leader>dl", dap.run_last, desc = "Debug: Run Last" },

        {
          "<leader>du",
          function()
            if dapui_ok then
              dapui.toggle()
            end
          end,
          desc = "Debug: Toggle UI",
        },

        -- Stop
        {
          "<F8>",
          function()
            if vim.fn.mode() == "t" then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
            end
            dap.terminate()
          end,
          mode = { "n", "i", "t" },
          desc = "Debug: Stop",
          silent = true,
        },
        {
          "<leader>dx",
          function()
            dap.terminate()
          end,
          desc = "Debug: Stop",
        },

        -- Python test helpers
        {
          "<leader>dtm",
          function()
            require("dap-python").test_method()
          end,
          desc = "Debug: Python test (method)",
        },
        {
          "<leader>dtc",
          function()
            require("dap-python").test_class()
          end,
          desc = "Debug: Python test (class)",
        },
      }
    end,

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▶" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {},
        expand_lines = true,
        controls = { enabled = true, element = "repl" },
        floating = { border = "single", mappings = { close = { "q", "<Esc>" } } },
        windows = { indent = 1 },
        render = { max_type_length = nil, max_value_lines = 100 },
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

      -- Auto-scroll DAP REPL (robust: based on filetype)
      local aug = vim.api.nvim_create_augroup("DapReplAutoscroll", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = aug,
        pattern = "dap-repl",
        callback = function(args)
          local bufnr = args.buf

          -- Only scroll when new output arrives (TextChanged),
          -- NOT while you're typing (TextChangedI).
          vim.api.nvim_create_autocmd("TextChanged", {
            group = aug,
            buffer = bufnr,
            callback = function()
              local win = vim.fn.bufwinid(bufnr)
              if win == -1 then
                return
              end

              -- If you're currently in insert mode, don't move cursor.
              if vim.fn.mode():match("i") then
                return
              end

              vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(bufnr), 0 })
            end,
          })
        end,
      })

      -- Python adapter (debugpy)
      local mason_dbgpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local function resolve_debugpy_python()
        if vim.fn.executable(mason_dbgpy) == 1 then
          return mason_dbgpy
        end
        local p3 = vim.fn.exepath("python3")
        if p3 ~= "" then
          return p3
        end
        return vim.fn.exepath("python")
      end

      local function python_from_venv()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and #venv > 0 then
          return venv .. "/bin/python"
        end
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
        return resolve_debugpy_python()
      end

      require("dap-python").setup(resolve_debugpy_python())
      require("dap-python").test_runner = "pytest"

      dap.configurations.python = {
        {
          type = "python",
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

      -- Highlight current execution line (theme-friendly)
      vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual" })
      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DapStoppedLine",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedLine",
      })
    end,
  },
}
