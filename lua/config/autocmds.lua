-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- -- Diff highlight colors — readable on solarized-osaka dark + transparent bg
-- local function apply_diff_highlights()
--   vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#1e3a28", fg = "#87af87" })
--   vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a1e1e", fg = "#af8787" })
--   vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1e2a3a" })
--   vim.api.nvim_set_hl(0, "DiffText",   { bg = "#3a3000", fg = "#d7af5f", bold = true })
-- end
-- -- Re-apply after every colorscheme load (solarized-osaka resets these on load)
-- vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_diff_highlights })
-- -- Also schedule for after the initial colorscheme finishes (VeryLazy fires mid-load)
-- vim.schedule(apply_diff_highlights)
--
-- -- Cleaner diff windows: hide sign/fold columns, disable wrap
-- vim.api.nvim_create_autocmd("OptionSet", {
--   pattern = "diff",
--   callback = function()
--     if vim.v.option_new == "1" then
--       vim.opt_local.foldcolumn = "0"
--       vim.opt_local.signcolumn = "no"
--       vim.opt_local.wrap       = false
--     end
--   end,
-- })
--
-- Search highlights: all matches in yellow, active match in red, typing match in orange
local function apply_search_highlights()
  vim.api.nvim_set_hl(0, "Search",    { bg = "#b58900", fg = "#002b36" })           -- all matches
  vim.api.nvim_set_hl(0, "CurSearch", { bg = "#dc322f", fg = "#fdf6e3", bold = true }) -- cursor match
  vim.api.nvim_set_hl(0, "IncSearch", { bg = "#cb4b16", fg = "#fdf6e3", bold = true }) -- while typing
end
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_search_highlights })
vim.schedule(apply_search_highlights)

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
