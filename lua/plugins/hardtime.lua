return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    opts = {
      -- Show a hint popup when a bad pattern is detected
      hint = true,
      notification = true,
      -- Allow some repeated keys (e.g. in scroll) before warning
      max_count = 3,
      -- Disable in these filetypes
      disabled_filetypes = {
        "qf", "netrw", "NvimTree", "lazy", "mason", "oil",
        "neo-tree", "TelescopePrompt", "snacks_picker_input",
      },
      -- Keys to restrict repeated use
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n", "x" },
        ["k"] = { "n", "x" },
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<Up>"] = { "n", "x", "i" },
        ["<Down>"] = { "n", "x", "i" },
        ["<Left>"] = { "n", "x", "i" },
        ["<Right>"] = { "n", "x", "i" },
      },
      -- Patterns that trigger a hint with a suggested alternative
      hints = {
        -- Esc abuse patterns
        ["^i<Esc>i$"] = {
          message = function()
            return "Use <C-o> for a single action instead of Esc → i"
          end,
          length = 5,
        },
        ["^<Esc>i$"] = {
          message = function()
            return "Re-entering insert? Use a (after), A (end of line), o (below), O (above)"
          end,
          length = 4,
        },
        -- Paste pattern
        ["^<Esc>pi$"] = {
          message = function()
            return "Use <C-r>0 to paste from yank register without leaving insert mode"
          end,
          length = 5,
        },
        -- New line pattern
        ["^<Esc>oi$"] = {
          message = function()
            return "Use <C-o>o instead of Esc → o → i"
          end,
          length = 5,
        },
        ["^<Esc>Oi$"] = {
          message = function()
            return "Use <C-o>O instead of Esc → O → i"
          end,
          length = 5,
        },
        -- End of line to insert
        ["^<Esc>A$"] = {
          message = function()
            return "Use <C-o>A instead of Esc → A"
          end,
          length = 4,
        },
      },
    },
    config = function(_, opts)
      require("hardtime").setup(opts)
      vim.g._hardtime_enabled = true -- mirrors default enabled = true
    end,
    keys = {
      {
        "<leader>Th",
        function()
          local ht = require("hardtime")
          vim.g._hardtime_enabled = not vim.g._hardtime_enabled
          if vim.g._hardtime_enabled then
            ht.enable()
            vim.notify("Hardtime ON — bad habits will be flagged", vim.log.levels.INFO, { title = "Hardtime" })
          else
            ht.disable()
            vim.notify("Hardtime OFF", vim.log.levels.WARN, { title = "Hardtime" })
          end
        end,
        desc = "Toggle Hardtime",
      },
      { "<leader>Tr", "<cmd>Hardtime report<cr>", desc = "Hardtime report" },
    },
  },
}
