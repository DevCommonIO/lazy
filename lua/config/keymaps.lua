local discipline = require("moonlucas.discipline")
discipline.cowboy()

local keymap = vim.keymap

-- Do things without affecting the registers
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "<Leader>p", '"0p', { desc = "Paste last yanked text after" })
keymap.set("n", "<Leader>P", '"0P', { desc = "Paste last yanked text before" })
keymap.set("v", "<Leader>p", '"0p', { desc = "Paste last yanked text" })

keymap.set({ "n", "v" }, "<Leader>d", '"_d', { desc = "Delete (no yank)" })
keymap.set({ "n", "v" }, "<Leader>D", '"_D', { desc = "Delete to end of line (no yank)" })
keymap.set({ "n", "v" }, "<Leader>r", '"_c', { desc = "Change (no yank)" })
keymap.set({ "n", "v" }, "<Leader>R", '"_C', { desc = "Change to end of line (no yank)" })

-- Increment/decrement (dial already gives <C-a>/<C-x> via expr mapping if you want)
keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- Keep native dw. Put "delete previous word (no yank)" under leader.
keymap.set("n", "<leader>dw", 'vb"_d', { desc = "Delete previous word (no yank)" })

-- Select all (don’t steal <C-a>)
keymap.set("n", "<leader>A", "gg<S-v>G", { desc = "Select all" })

-- Disable comment continuation on new line
keymap.set("n", "<Leader>o", "o<Esc>^Da", { desc = "New line below (no comment continuation)" })
keymap.set("n", "<Leader>O", "O<Esc>^Da", { desc = "New line above (no comment continuation)" })

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

-- Tabs (optional: consider removing if you don’t use tabs often)
keymap.set("n", "te", ":tabedit ", { desc = "New tab" })
keymap.set("n", "<tab>", ":tabnext<Return>", { desc = "Next tab" })
keymap.set("n", "<s-tab>", ":tabprev<Return>", { desc = "Previous tab" })

-- Splits
keymap.set("n", "ss", "<C-w>s", { desc = "Horizontal split" })
keymap.set("n", "sv", "<C-w>v", { desc = "Vertical split" })

-- Move window
keymap.set("n", "sh", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "sk", "<C-w>k", { desc = "Focus upper window" })
keymap.set("n", "sj", "<C-w>j", { desc = "Focus lower window" })
keymap.set("n", "sl", "<C-w>l", { desc = "Focus right window" })

-- Extra window ops (optional, but consistent with "s = windows")
keymap.set("n", "sq", "<C-w>q", { desc = "Close window" })
keymap.set("n", "so", "<C-w>o", { desc = "Only window" })
keymap.set("n", "s=", "<C-w>=", { desc = "Equalize windows" })

-- Resize window
keymap.set("n", "<M-left>", "<C-w><", { desc = "Resize window left" })
keymap.set("n", "<M-right>", "<C-w>>", { desc = "Resize window right" })
keymap.set("n", "<M-up>", "<C-w>+", { desc = "Resize window up" })
keymap.set("n", "<M-down>", "<C-w>-", { desc = "Resize window down" })

-- Custom tools
keymap.set("n", "<leader>i", function()
  require("moonlucas.lsp").toggleInlayHints()
end, { desc = "Toggle inlay hints" })

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("moonlucas.lsp").toggleAutoformat()
end, {})
