return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- Go forward/backward with square brackets
  {
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")
      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- Better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-l>",
          accept_line = "<M-S-l>",
          next = "<C-]>",
          prev = "<C-[>",
          dismiss = "<C-;>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
        ["dap-repl"] = false,
        ["TelescopePrompt"] = false,
      },
    },
    keys = {
      {
        "<leader>ap",
        function()
          local suggestion = require("copilot.suggestion")
          suggestion.toggle_auto_trigger()

          if suggestion.is_auto_trigger_enabled() then
            vim.notify("Copilot Enabled", vim.log.levels.INFO)
          else
            vim.notify("Copilot Disabled", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Copilot",
      },
    },
  },
}
