-- File: lua/plugins/ts-autotag.lua
return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- ✅ new setup options layout
      opts = {
        enable_close = true, -- auto close tags
        enable_rename = true, -- auto rename pairs of tags
        enable_close_on_slash = true, -- auto close on trailing </
      },

      -- optional per-filetype overrides
      per_filetype = {
        -- ["html"] = { enable_close = false },
      },
    },
  },
}
