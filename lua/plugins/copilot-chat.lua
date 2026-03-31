-- File: lua/plugins/copilot-chat.lua
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    opts = {
      help = { providers = { "contexts", "commands", "prompts" } },
      model = "claude-sonnet-4.6",
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
        require("CopilotChat").open()
        vim.schedule(function()
          vim.api.nvim_feedkeys(text, "t", false)
        end)
      end

      local function add_all_open_buffers_as_files(max_files)
        require("CopilotChat").open()
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

      return {
        { "<leader>C", desc = "Copilot Chat", mode = { "n", "v" } },

        {
          "<leader>Ca",
          function() require("CopilotChat").open() end,
          desc = "Open Chat",
          mode = { "n", "v" },
        },
        {
          "<leader>Ct",
          function() require("CopilotChat").toggle() end,
          desc = "Toggle Chat",
          mode = { "n", "v" },
        },

        {
          "<leader>Cq",
          function()
            local chat = require("CopilotChat")
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
          "<leader>Cb",
          function() open_and_insert("#buffer:active ") end,
          desc = "Insert #buffer:active",
          mode = { "n", "v" },
        },
        {
          "<leader>CS",
          function() open_and_insert("#selection ") end,
          desc = "Insert #selection",
          mode = { "n", "v" },
        },

        {
          "<leader>CB",
          function() add_all_open_buffers_as_files(12) end,
          desc = "Add open buffers as #file",
          mode = { "n", "v" },
        },

        {
          "<leader>Cr",
          function() open_and_insert("/Review #buffer:active\n") end,
          desc = "Review buffer",
          mode = "n",
        },
        {
          "<leader>Ce",
          function() open_and_insert("/Explain #selection\n") end,
          desc = "Explain selection",
          mode = "v",
        },
        {
          "<leader>Cc",
          function() open_and_insert("/Commit #gitdiff:staged\n") end,
          desc = "Commit message",
          mode = "n",
        },

        {
          "<leader>Cx",
          function() require("CopilotChat").reset() end,
          desc = "Reset Chat",
          mode = { "n", "v" },
        },
      }
    end,
  },
}
