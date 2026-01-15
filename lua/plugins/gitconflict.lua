-- File: lua/plugins/git-conflict.lua
-- Lean + consistent with the Git contract:
--   - <leader>g... = Git
--   - <leader>gm... = Merge (conflicts)
--   - [h ]h = hunks (gitsigns)
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre", -- conflicts appear when you open files, so load earlier than VeryLazy
  config = function()
    require("git-conflict").setup({
      default_mappings = false,
      disable_diagnostics = true, -- keeps diagnostics from screaming during conflict resolution
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })

    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    -- Actions
    map("n", "<leader>gmo", "<Plug>(git-conflict-ours)", vim.tbl_extend("force", opts, { desc = "Merge: Use ours" }))
    map(
      "n",
      "<leader>gmt",
      "<Plug>(git-conflict-theirs)",
      vim.tbl_extend("force", opts, { desc = "Merge: Use theirs" })
    )
    map("n", "<leader>gmb", "<Plug>(git-conflict-both)", vim.tbl_extend("force", opts, { desc = "Merge: Use both" }))
    map("n", "<leader>gmn", "<Plug>(git-conflict-none)", vim.tbl_extend("force", opts, { desc = "Merge: Use none" }))

    -- Navigation (keep your j/k habit)
    map(
      "n",
      "<leader>gmj",
      "<Plug>(git-conflict-next-conflict)",
      vim.tbl_extend("force", opts, { desc = "Merge: Next conflict" })
    )
    map(
      "n",
      "<leader>gmk",
      "<Plug>(git-conflict-prev-conflict)",
      vim.tbl_extend("force", opts, { desc = "Merge: Prev conflict" })
    )

    -- which-key (new spec) – minimal, just the group name (descs already come from keymaps)
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>g", group = "git" },
        { "<leader>gm", group = "merge" },
      })
    end
  end,
}
