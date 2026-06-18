-- java-darcula → classic IntelliJ IDEA "Darcula" dark
-- Aliases darcula-dark (darcula-dark.nvim). A nested `:colorscheme` gets
-- overridden by Neovim's reentrancy guard, so call the plugin's setup directly.
require("lazy").load({ plugins = { "darcula-dark.nvim" } })
require("darcula").setup()
