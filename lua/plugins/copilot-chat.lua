return {
  -- Core Copilot (keep if you use it elsewhere)
  { "zbirenbaum/copilot.lua", cmd = "Copilot", event = "InsertEnter", opts = {} },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    -- Keep opts simple; don't require plugin internals here
    opts = {
      -- window = { layout = "", width = 0.45, height = 0.6, border = "rounded" },
      help = { providers = { "contexts", "commands", "prompts" } }, -- show contexts in help
      -- Prompts that don't need requires
      prompts = {
        ["Explain Selection"] = {
          prompt = "Explain the selected code in detail and suggest improvements.",
          system_prompt = "#selection",
          selection = true,
        },
        ["Review Current Buffer"] = {
          prompt = "Review the current buffer and provide actionable improvements.",
          system_prompt = "#buffer",
          selection = false,
        },
        ["Review All Open Buffers"] = {
          prompt = "Review all open buffers together and provide a concise report.",
          system_prompt = "#buffers",
          selection = false,
        },
        ["Commit Message (Staged)"] = {
          prompt = "Generate a concise, conventional commit message for the staged changes.",
          system_prompt = "#git:staged",
          selection = false,
        },
      },
    },

    -- If you want to explicitly register contexts, do it AFTER load
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      -- Optional: only if available (guards against API changes)
      local ok, ctx = pcall(require, "CopilotChat.context")
      if ok and ctx then
        require("CopilotChat").set_contexts({
          buffer = ctx.buffer,
          buffers = ctx.buffers,
          file = ctx.file,
          files = ctx.files,
          git = ctx.git,
          selection = ctx.selection,
        })
      end
    end,

    keys = function()
      local keys = {
        { "<leader>a", desc = "AI", mode = { "n", "v" } },

        -- Open/Toggle
        {
          "<leader>aa",
          function()
            require("CopilotChat").open()
          end,
          desc = "Open Chat",
          mode = { "n", "v" },
        },
        {
          "<leader>at",
          function()
            require("CopilotChat").toggle()
          end,
          desc = "Toggle Chat",
          mode = { "n", "v" },
        },

        -- Ask (prefers selection if in visual mode)
        {
          "<leader>aq",
          function()
            local chat = require("CopilotChat")
            if vim.fn.mode():match("[vV\22]") then
              chat.ask({ selection = true })
            else
              chat.ask({})
            end
          end,
          desc = "Ask (selection if visual)",
          mode = { "n", "v" },
        },

        -- Quick context inserters
        {
          "<leader>ab",
          function()
            require("CopilotChat").open()
            vim.schedule(function()
              vim.api.nvim_feedkeys("#buffer ", "t", false)
            end)
          end,
          desc = "Insert #buffer",
          mode = { "n", "v" },
        },
        -- lua/plugins/copilot-chat.lua (inside the CopilotChat spec's keys)
        {
          "<leader>aB",
          function()
            local chat = require("CopilotChat")
            chat.open()
            vim.schedule(function()
              local bufs = vim.fn.getbufinfo({ buflisted = 1 })
              local lines = {}
              for _, b in ipairs(bufs) do
                if b.name ~= "" and vim.fn.filereadable(b.name) == 1 then
                  table.insert(lines, "#file:" .. b.name)
                end
              end
              if #lines > 0 then
                vim.api.nvim_feedkeys(table.concat(lines, "\n") .. "\n", "t", false)
              end
            end)
          end,
          desc = "CopilotChat: add all open buffers as context",
          mode = { "n", "v" },
        },
        {
          "<leader>aS",
          function()
            require("CopilotChat").open()
            vim.schedule(function()
              vim.api.nvim_feedkeys("#selection ", "t", false)
            end)
          end,
          desc = "Insert #selection",
          mode = { "n", "v" },
        },

        -- Predefined prompts
        {
          "<leader>ar",
          function()
            require("CopilotChat").select_prompt("Review Current Buffer")
          end,
          desc = "Review current buffer",
          mode = "n",
        },
        {
          "<leader>aR",
          function()
            require("CopilotChat").select_prompt("Review All Open Buffers")
          end,
          desc = "Review all open buffers",
          mode = "n",
        },
        {
          "<leader>ae",
          function()
            require("CopilotChat").select_prompt("Explain Selection")
          end,
          desc = "Explain selection",
          mode = "v",
        },
        {
          "<leader>ac",
          function()
            require("CopilotChat").select_prompt("Commit Message (Staged)")
          end,
          desc = "Commit message (staged)",
          mode = "n",
        },
        {
          "<leader>ax",
          function()
            require("CopilotChat").reset()
          end,
          desc = "Reset Chat",
          mode = { "n", "v" },
        },
      }
      return keys
    end,
  },
}
