return {
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
    keys = {
      {
        "<leader>fs",
        function()
          require("telescope").extensions.luasnip.luasnip()
        end,
        desc = "Find Snippets",
      },
    },
  },
}
