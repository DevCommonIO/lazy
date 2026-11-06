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

-- Jumplist: <C-o> back / <C-i> forward both work natively -- no mapping needed.
-- Do NOT map <C-m> to <C-i>: <C-m> is the same keycode as <CR>, so it hijacks
-- Enter in normal mode.

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

-- Tabs
-- NOTE: <tab> is NOT mapped here on purpose. <Tab> and <C-i> are the same
-- keycode, so mapping <tab> in normal mode silently breaks <C-i>
-- (jumplist forward). Use the built-in gt / gT to cycle tabs instead.
keymap.set("n", "te", ":tabedit ", { desc = "New tab" })

-- Split / close windows (s prefix; plain `s` is still Flash jump)
keymap.set("n", "ss", "<cmd>split<CR>", { desc = "Split window below" })
keymap.set("n", "sv", "<cmd>vsplit<CR>", { desc = "Split window right" })
keymap.set("n", "sq", "<C-w>q", { desc = "Close window" })
keymap.set("n", "so", "<C-w>o", { desc = "Only this window" })

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

-- Resize window: <M-arrows> and <M-h/j/k/l> focus live in lua/plugins/smart-splits.lua
-- (shared with tmux panes).

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

-- Cheatsheet floating windows: <leader>? = full reference, <leader>H = daily workflow
local function open_cheatsheet(file, title)
  local path = vim.fn.stdpath("config") .. "/" .. file
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.fn.readfile(path)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf })
end

keymap.set("n", "<leader>?", function()
  open_cheatsheet("SHORTCUTS.md", " Shortcuts ")
end, { desc = "Shortcuts cheatsheet" })
keymap.set("n", "<leader>H", function()
  open_cheatsheet("DAILY.md", " Daily workflow ")
end, { desc = "Daily workflow cheatsheet" })
