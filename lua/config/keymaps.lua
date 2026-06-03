local keymap = vim.keymap

-- Do things without affecting the registers
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "<Leader>p", '"0p', { desc = "Paste last yanked text after" })
keymap.set("n", "<Leader>P", '"0P', { desc = "Paste last yanked text before" })
keymap.set("v", "<Leader>p", '"0p', { desc = "Paste last yanked text" })

-- Move line up/down in normal mode (uppercase avoids tmux M-j/M-k conflict)
keymap.set("n", "<A-J>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-K>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- Move selection in visual mode
keymap.set("v", "<A-J>", "<cmd>m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-K>", "<cmd>m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep native dw. Put "delete word under cursor (no yank)" under leader.
keymap.set("n", "<leader>dw", '"_daw', { desc = "Delete word under cursor (no yank)" })

-- Select all (don’t steal <C-a>)
keymap.set("n", "<leader>A", "gg<S-v>G", { desc = "Select all" })

-- Disable comment continuation on new line
keymap.set("n", "<Leader>o", 'o<Esc>"_S', { desc = "New line below (no comment continuation)" })
keymap.set("n", "<Leader>O", 'O<Esc>"_S', { desc = "New line above (no comment continuation)" })

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

-- Centered scrolling — never lose cursor position
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
keymap.set("n", "n", "nzzzv", { desc = "Next search (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

-- Yank to system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- Exit insert mode quickly
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Tabs (optional: consider removing if you don’t use tabs often)
keymap.set("n", "te", ":tabedit ", { desc = "New tab" })
keymap.set("n", "<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap.set("n", "<s-tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Move window
keymap.set("n", "sh", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "sk", "<C-w>k", { desc = "Focus upper window" })
keymap.set("n", "sj", "<C-w>j", { desc = "Focus lower window" })
keymap.set("n", "sl", "<C-w>l", { desc = "Focus right window" })

-- Terminal-only window navigation
keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Focus left window" })
keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Focus lower window" })
keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Focus upper window" })
keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Focus right window" })
-- Enter normal mode inside terminal (to scroll/visual/yank), then i/a to return
keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal → normal mode" })

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

-- <leader>id: avoids conflict with <leader>dt* debug-test keymaps in dap.lua
keymap.set("n", "<leader>id", function()
  local date = os.date("%Y-%m-%d %H:%M")
  vim.api.nvim_put({ "## " .. date, "" }, "l", true, true)
end, { desc = "Insert Date Heading" })

-- Scratch: new (timestamped) in Markdown
vim.keymap.set("n", "<leader>xn", function()
  local name = "scratch_" .. os.date("%Y%m%d_%H%M%S")
  Snacks.scratch({ name = name, ft = "markdown" })
end, { desc = "New Scratch (timestamped)" })
