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
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "oil",
        "neo-tree",
        "TelescopePrompt",
        "snacks_picker_input",
      },
      -- Empty tables fully remove hardtime's internal arrow disable (which blocks all modes)
      disabled_keys = {
        ["<Up>"] = {},
        ["<Down>"] = {},
        ["<Left>"] = {},
        ["<Right>"] = {},
        ["j"] = {},
        ["k"] = {},
      },

      -- Keys to restrict repeated use
      restricted_keys = {
        ["h"] = { "n", "x" },
        -- Empty tables override hardtime's defaults so j/k are never flagged when repeated
        ["j"] = {},
        ["k"] = {},
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<Up>"] = { "n", "x" },
        ["<Down>"] = { "n", "x" },
        ["<Left>"] = { "n", "x" },
        ["<Right>"] = { "n", "x" },
      },
      -- Patterns that trigger a hint with a suggested alternative
      hints = {
        -- Re-entering insert right after escaping
        ["^<Esc>i$"] = {
          message = function()
            return "Re-entering insert? i = before cursor. Use: a (after), A (end of line), o (below), O (above)"
          end,
          length = 3,
        },

        -- Esc → action → i (use <C-o> instead)
        ["^<Esc>oi$"] = {
          message = function()
            return "Esc → o → i: use <C-o>o to open line below and stay in insert"
          end,
          length = 4,
        },
        ["^<Esc>Oi$"] = {
          message = function()
            return "Esc → O → i: use <C-o>O to open line above and stay in insert"
          end,
          length = 4,
        },
        ["^<Esc>Ai$"] = {
          message = function()
            return "Esc → A → i: just use A directly from insert with <C-o>A"
          end,
          length = 4,
        },
        ["^<Esc>ddi$"] = {
          message = function()
            return "Esc → dd → i: use <C-o>dd to delete line and stay in insert"
          end,
          length = 5,
        },
        ["^<Esc>ui$"] = {
          message = function()
            return "Esc → u → i: use <C-o>u to undo and stay in insert"
          end,
          length = 4,
        },
        ["^<Esc>wi$"] = {
          message = function()
            return "Esc → w → i: use <C-o>w to jump word forward and stay in insert"
          end,
          length = 4,
        },
        ["^<Esc>bi$"] = {
          message = function()
            return "Esc → b → i: use <C-o>b to jump word backward and stay in insert"
          end,
          length = 4,
        },

        -- o already enters insert — pressing i after is redundant (types literal "i")
        ["^<Esc>oi$"] = {
          message = function()
            return "o already enters insert mode — no need for i after. From insert use <C-o>o instead of Esc → o"
          end,
          length = 4,
        },
        ["^<Esc>Oi$"] = {
          message = function()
            return "O already enters insert mode — no need for i after. From insert use <C-o>O instead of Esc → O"
          end,
          length = 4,
        },

        -- Coming back to insert after operation: use the right command, not always i
        ["^<Esc>wi$"] = {
          message = function()
            return "After w, use a (after cursor) or A (end of line) instead of i — i inserts before cursor"
          end,
          length = 4,
        },
        ["^<Esc>bi$"] = {
          message = function()
            return "After b, think: do you want a (after), A (end of line), o (below), O (above)? Not always i"
          end,
          length = 4,
        },

        -- Paste then re-enter insert
        ["^<Esc>pi$"] = {
          message = function()
            return "Esc → p → i: use <C-r>0 to paste from yank register without leaving insert"
          end,
          length = 4,
        },
        ["^<Esc>Pi$"] = {
          message = function()
            return "Esc → P → i: use <C-r>0 to paste from yank register without leaving insert"
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
