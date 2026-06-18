-- java-darcula-new → IntelliJ "New UI" dark (2023+)
-- Aliases neodarcula (neodarcula.nvim).
require("lazy").load({ plugins = { "neodarcula.nvim" } })
vim.g.colors_name = "neodarcula"
require("neodarcula").load()
