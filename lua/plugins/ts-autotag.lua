-- File: lua/plugins/ts-autotag.lua
return {
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- defaults are good; keep explicit for clarity
      enable = true,
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  },
}
