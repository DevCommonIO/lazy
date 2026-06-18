-- java-light → clean light scheme with an "IntelliJ Light" feel
-- Aliases catppuccin-latte. Transparency off for a true light IDE look.
require("lazy").load({ plugins = { "catppuccin" } })
require("catppuccin").setup({ transparent_background = false, flavour = "latte" })
require("catppuccin").load("latte")
