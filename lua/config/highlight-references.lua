local function set_reference_highlight()
  -- LSP document highlights
  vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })

  -- vim-illuminate (LazyVim uses this by default)
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
end

set_reference_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_reference_highlight,
})
