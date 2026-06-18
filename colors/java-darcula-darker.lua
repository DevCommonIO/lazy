-- java-darcula-darker → deeper-background Darcula variant
-- Uses darcula-dark.nvim's bundled "darcula-darker" theme JSON (no registered
-- colors file of its own), so we load the plugin and apply the theme directly.
require("lazy").load({ plugins = { "darcula-dark.nvim" } })
require("darcula").setup({ theme = "darcula-darker-example" })
