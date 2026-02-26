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
vim.opt.mouse = ""

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
vim.opt.clipboard = "unnamedplus"

-- =====================================================
-- Shell
-- =====================================================
vim.opt.shell = "fish"

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
-- Better editing UX
-- =====================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Keep cursor position when reopening files
vim.opt.viewoptions = { "cursor", "folds" }
