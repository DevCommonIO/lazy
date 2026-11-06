-- Key overrides for LazyVim-provided plugins (see DAILY.md "Known quirks").
return {
  -- Incremental selection: <C-Space> is the tmux prefix and never reaches nvim,
  -- so use Alt+Space (grow) / Backspace (shrink) instead.
  {
    "folke/flash.nvim",
    keys = {
      { "<c-space>", false, mode = { "n", "o", "x" } },
      {
        "<M-Space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = { ["<M-Space>"] = "next", ["<BS>"] = "prev" },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
  },

  -- Keep <leader>p for "paste last yank" (lua/config/keymaps.lua); move the
  -- yank history picker to <leader>sy.
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false, mode = { "n", "x" } },
      {
        "<leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        mode = { "n", "x" },
        desc = "Yank History",
      },
    },
  },
}
