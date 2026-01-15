return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.spec = opts.spec or {}

      -- Tell which-key that ";" is a prefix and give it a name
      table.insert(opts.spec, { ";", group = "Search" })

      -- (optional) also label your AI prefix if you want
      table.insert(opts.spec, { "<leader>a", group = "AI" })
      table.insert(opts.spec, { "<leader>d", group = "Debug" })

      return opts
    end,
  },
}
