local discipline = require("moonlucas.discipline")
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "<Leader>p", '"0p', { desc = "Paste last yanked text after" })
keymap.set("n", "<Leader>P", '"0P', { desc = "Paste last yanked text before" })
keymap.set("v", "<Leader>p", '"0p', { desc = "Paste last yanked text" })
keymap.set("n", "<Leader>c", '"_c', { desc = "Change text (no yank)" })
keymap.set("n", "<Leader>C", '"_C', { desc = "Change to end of line (no yank)" })
keymap.set("v", "<Leader>c", '"_c', { desc = "Change selection (no yank)" })
keymap.set("v", "<Leader>C", '"_C', { desc = "Change selection to EOL (no yank)" })
keymap.set("n", "<Leader>d", '"_d', { desc = "Delete (no yank)" })
keymap.set("n", "<Leader>D", '"_D', { desc = "Delete to end of line (no yank)" })
keymap.set("v", "<Leader>d", '"_d', { desc = "Delete selection (no yank)" })
keymap.set("v", "<Leader>D", '"_D', { desc = "Delete selection to EOL (no yank)" })

-- Increment/decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', { desc = "Delete word backwards (no yank)" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", { desc = "Insert new line below (no comment continuation)" })
keymap.set("n", "<Leader>O", "O<Esc>^Da", { desc = "Insert new line above (no comment continuation)" })

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

-- New tab
keymap.set("n", "te", ":tabedit", { desc = "New tab" })
keymap.set("n", "<tab>", ":tabnext<Return>", { desc = "Next tab" })
keymap.set("n", "<s-tab>", ":tabprev<Return>", { desc = "Previous tab" })

-- Split window
keymap.set("n", "ss", ":split<Return>", { desc = "Horizontal split" })
keymap.set("n", "sv", ":vsplit<Return>", { desc = "Vertical split" })

-- Move window
keymap.set("n", "sh", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "sk", "<C-w>k", { desc = "Focus upper window" })
keymap.set("n", "sj", "<C-w>j", { desc = "Focus lower window" })
keymap.set("n", "sl", "<C-w>l", { desc = "Focus right window" })

-- Resize window
keymap.set("n", "<M-left>", "<C-w><", { desc = "Resize window left" })
keymap.set("n", "<M-right>", "<C-w>>", { desc = "Resize window right" })
keymap.set("n", "<M-up>", "<C-w>+", { desc = "Resize window up" })
keymap.set("n", "<M-down>", "<C-w>-", { desc = "Resize window down" })

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, { desc = "Go to next diagnostic" })

-- Custom tools
keymap.set("n", "<leader>r", function()
  require("moonlucas.hsl").replaceHexWithHSL()
end, { desc = "Replace HEX with HSL" })

keymap.set("n", "<leader>i", function()
  require("moonlucas.lsp").toggleInlayHints()
end, { desc = "Toggle inlay hints" })

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("moonlucas.lsp").toggleAutoformat()
end, {})
