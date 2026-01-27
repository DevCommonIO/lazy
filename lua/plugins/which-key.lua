return {
  {
    "folke/which-key.nvim",
    keys = {
      { ";", mode = { "n", "v" } },
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.spec = opts.spec or {}

      opts.delay = 200

      table.insert(opts.spec, { ";", group = "Search" })
      table.insert(opts.spec, { "<leader>a", group = "AI" })
      table.insert(opts.spec, { "<leader>d", group = "Debug" })

      return opts
    end,
  },
}
