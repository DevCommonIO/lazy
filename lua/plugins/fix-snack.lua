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

      return opts
    end,
  },
}
