return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- make sure opts exists
      opts = opts or {}

      -- 1. disable the explorer watcher so Snacks won't try to live-refresh
      opts.explorer = opts.explorer or {}
      opts.explorer.watch = false

      -- 2. ensure picker tables exist so update_titles() won't explode on nil
      opts.picker = opts.picker or {}
      opts.picker.titles = opts.picker.titles or {}

      -- 🔥 ADD THIS
      opts.explorer.hidden = true -- show hidden files
      opts.explorer.ignored = true -- show gitignored files (optional)

      return opts
    end,

    keys = {
      -- Reorganize explorer keymaps under <leader>e (was a single <leader>e / <leader>E)
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>ee",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer (root dir)",
      },
      {
        "<leader>eE",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer (cwd)",
      },
      {
        "<leader>ef",
        function()
          Snacks.explorer.reveal()
        end,
        desc = "Explorer (focus current file)",
      },
      {
        "<leader>eo",
        function()
          vim.ui.open(vim.fn.expand("%:p:h"))
        end,
        desc = "Open in Finder (current file dir)",
      },
    },
  },
}
