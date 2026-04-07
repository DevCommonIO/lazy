return {
  -- Split/join code blocks (objects, arrays, function args, etc.)
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Toggle split/join block" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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

  -- Better increase/decrease — normal + visual mode
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      { "<C-a>", function() return require("dial.map").inc_visual() end, mode = "v", expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_visual() end, mode = "v", expr = true, desc = "Decrement" },
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

  -- Extract function/variable refactors (VSCode-like refactor menu)
  -- Visual select code → <leader>re to pick refactor, or direct shortcuts below
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>re", function() require("refactoring").select_refactor() end, mode = { "n", "x" }, desc = "Refactor" },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function") end, mode = "x", desc = "Extract Function" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, mode = "x", desc = "Extract Variable" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "x" }, desc = "Inline Variable" },
    },
    config = true,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept      = "<C-l>",
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          next        = "<C-]>",
          prev        = "<C-[>",
          dismiss     = "<C-;>",
        },
      },
      filetypes = {
        markdown = true,
        help     = true,
        ["dap-repl"]        = false,
        ["TelescopePrompt"] = false,
      },
    },
    keys = {
      {
        "<leader>ap",
        function()
          local suggestion = require("copilot.suggestion")
          suggestion.toggle_auto_trigger()
          vim.notify(
            suggestion.is_auto_trigger_enabled() and "Copilot Enabled" or "Copilot Disabled",
            suggestion.is_auto_trigger_enabled() and vim.log.levels.INFO or vim.log.levels.WARN
          )
        end,
        desc = "Toggle Copilot",
      },
    },
  },
}
