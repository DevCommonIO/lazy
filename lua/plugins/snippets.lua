return {
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy", -- ✅ load before you open the picker
    version = "v2.*",
    build = (not vim.fn.has("win32")) and "make install_jsregexp" or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      ls.config.setup({ history = true, updateevents = "TextChanged,TextChangedI" })

      -- VSCode snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Your custom snippets folder (if you use it)
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })
    end,
  },
}
