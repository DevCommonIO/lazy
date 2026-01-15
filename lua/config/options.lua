-- File: lua/config/options.lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- UI
vim.opt.number = true
vim.opt.title = true
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.mouse = ""

-- Command line height (modern UI)
-- Neovim supports cmdheight=0 on modern versions; works well with noice.nvim.
vim.opt.cmdheight = 0

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- IMPORTANT: makes searches case-sensitive if you type capitals

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

-- Files / wildmenu
vim.opt.backup = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Comments: continue comments on Enter (and optionally o/O)
vim.opt.formatoptions:append({ "r", "o" })

-- Shell
vim.opt.shell = "fish"

-- File types (prefer this over autocmd setf)
vim.filetype.add({
  extension = {
    mdx = "mdx",
    astro = "astro",
  },
  filename = {
    Podfile = "ruby",
  },
})

-- LazyVim switches
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"

vim.opt.showcmd = false
vim.opt.timeoutlen = 500
vim.opt.timeout = true

-- Optional: undercurl tweaks (legacy). Keep only if you KNOW you need it.
-- If you keep it, scope it to terminals that support it.
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])
