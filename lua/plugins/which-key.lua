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

      table.insert(opts.spec, { ";",          group = "Search" })
      table.insert(opts.spec, { "<leader>a",  group = "AI" })
      table.insert(opts.spec, { "<leader>C",  group = "Copilot" })
      table.insert(opts.spec, { "<leader>d",  group = "Debug" })
      table.insert(opts.spec, { "<leader>dt", group = "Debug: Test" })
      table.insert(opts.spec, { "<leader>h",  group = "Harpoon" })
      table.insert(opts.spec, { "<leader>i",  group = "Insert / Toggle" })
      table.insert(opts.spec, { "<leader>r",  group = "Refactor" })
      table.insert(opts.spec, { "<leader>T",  group = "Training" })

      return opts
    end,
  },
}
