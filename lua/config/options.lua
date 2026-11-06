-- =====================================================
-- Leader
-- =====================================================
vim.g.mapleader = " "

-- =====================================================
-- Encoding
-- =====================================================
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- =====================================================
-- UI
-- =====================================================
vim.opt.number = true
vim.opt.title = true
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.mouse = "a" -- tmux passes wheel/clicks through; Option+drag for terminal selection

-- Modern command line (works great with noice.nvim)
vim.opt.cmdheight = 0

-- =====================================================
-- Indentation (VSCode / IntelliJ feel)
-- =====================================================
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.autoindent = true
vim.opt.smartindent = false -- disable legacy heuristic
vim.opt.cindent = false -- avoid C-style indent rules
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.breakindent = true

vim.opt.backspace = { "start", "eol", "indent" }

-- =====================================================
-- Search
-- =====================================================
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- =====================================================
-- Splits
-- =====================================================
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

-- =====================================================
-- Files / Wildmenu
-- =====================================================
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({
  "*/node_modules/*",
  "*/dist/*",
  "*/.git/*",
})

-- =====================================================
-- Live substitution preview
-- =====================================================
vim.opt.inccommand = "split"

-- =====================================================
-- Comment behavior (VSCode-like Enter)
-- =====================================================
vim.opt.formatoptions:remove({ "o" }) -- don't auto continue comments
vim.opt.formatoptions:append({ "r" })

-- =====================================================
-- Clipboard (system copy/paste)
-- =====================================================
-- vim.opt.clipboard = "unnamedplus"

-- =====================================================
-- Shell
-- =====================================================
vim.opt.shell = "zsh" -- same shell as iTerm2 / tmux

-- =====================================================
-- Filetype additions
-- =====================================================
vim.filetype.add({
  extension = {
    mdx = "mdx",
    astro = "astro",
  },
  filename = {
    Podfile = "ruby",
  },
})

-- =====================================================
-- LazyVim switches
-- =====================================================
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"

-- =====================================================
-- Timing / responsiveness
-- =====================================================
vim.opt.timeout = true
vim.opt.timeoutlen = 400
vim.opt.updatetime = 200

vim.opt.showcmd = false

-- =====================================================
-- Diff algorithm
-- =====================================================
-- Set explicitly rather than :append() -- Neovim 0.12 ships indent-heuristic and
-- linematch:40 by default, so appending silently duplicated them.
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "inline:char", -- highlight changed text within a line
  "indent-heuristic", -- place hunks at natural code boundaries
  "algorithm:histogram", -- smarter than Myers (fewer spurious hunks)
  "linematch:60", -- match similar lines across hunks
  "context:5", -- show 5 lines of context around changes
}

-- =====================================================
-- Better editing UX
-- =====================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Jumplist behaves like browser back/forward
vim.opt.jumpoptions = "stack"

-- Allow cursor past line ends in visual block mode
vim.opt.virtualedit = "block"

-- Keep cursor position when reopening files
vim.opt.viewoptions = { "cursor", "folds" }

-- =====================================================
-- Terminal
-- =====================================================
-- Lines kept beyond the visible screen in terminal buffers (Claude, lazygit, etc).
-- Neovim's default is 10000, which long Claude conversations blow past -- older
-- lines are then deleted and become unscrollable. Max allowed is 1000000.
vim.opt.scrollback = 100000
