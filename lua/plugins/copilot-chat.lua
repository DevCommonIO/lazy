-- File: lua/plugins/copilot-chat.lua
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    opts = {
      help = { providers = { "contexts", "commands", "prompts" } },
      prompts = {
        ["Explain Selection"] = { prompt = "/Explain #selection" },
        ["Review Current Buffer"] = { prompt = "/Review #buffer:active" },
        ["Commit Message (Staged)"] = { prompt = "/Commit #gitdiff:staged" },
      },
    },

    config = function(_, opts)
      require("CopilotChat").setup(opts)
    end,

    keys = function()
      local function open_and_insert(text)
        local chat = require("CopilotChat")
        chat.open()
        vim.schedule(function()
          vim.api.nvim_feedkeys(text, "t", false)
        end)
      end

      local function add_all_open_buffers_as_files(max_files)
        local chat = require("CopilotChat")
        chat.open()
        vim.schedule(function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          local seen, lines, count = {}, {}, 0

          for _, b in ipairs(bufs) do
            local name = b.name
            if name ~= "" and vim.fn.filereadable(name) == 1 and not seen[name] then
              seen[name] = true
              table.insert(lines, "#file:" .. vim.fn.fnameescape(name))
              count = count + 1
              if max_files and count >= max_files then
                break
              end
            end
          end

          if #lines > 0 then
            vim.api.nvim_feedkeys(table.concat(lines, "\n") .. "\n", "t", false)
          end
        end)
      end

      local chat = require("CopilotChat")

      return {
        { "<leader>a", desc = "AI", mode = { "n", "v" } },

        {
          "<leader>aa",
          function()
            chat.open()
          end,
          desc = "Open Chat",
          mode = { "n", "v" },
        },
        {
          "<leader>at",
          function()
            chat.toggle()
          end,
          desc = "Toggle Chat",
          mode = { "n", "v" },
        },

        {
          "<leader>aq",
          function()
            if vim.fn.mode():match("[vV\22]") then
              chat.ask("#selection ")
            else
              chat.ask("")
            end
          end,
          desc = "Ask (selection if visual)",
          mode = { "n", "v" },
        },

        {
          "<leader>ab",
          function()
            open_and_insert("#buffer:active ")
          end,
          desc = "Insert #buffer:active",
          mode = { "n", "v" },
        },
        {
          "<leader>aS",
          function()
            open_and_insert("#selection ")
          end,
          desc = "Insert #selection",
          mode = { "n", "v" },
        },

        {
          "<leader>aB",
          function()
            add_all_open_buffers_as_files(12)
          end,
          desc = "Add open buffers as #file",
          mode = { "n", "v" },
        },

        {
          "<leader>ar",
          function()
            open_and_insert("/Review #buffer:active\n")
          end,
          desc = "Review buffer",
          mode = "n",
        },
        {
          "<leader>ae",
          function()
            open_and_insert("/Explain #selection\n")
          end,
          desc = "Explain selection",
          mode = "v",
        },
        {
          "<leader>ac",
          function()
            open_and_insert("/Commit #gitdiff:staged\n")
          end,
          desc = "Commit message",
          mode = "n",
        },

        {
          "<leader>ax",
          function()
            chat.reset()
          end,
          desc = "Reset Chat",
          mode = { "n", "v" },
        },
      }
    end,
  },
}
