return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("git-conflict").setup({
      default_mappings = false,
    })

    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    map("n", "<leader>gmo", "<Plug>(git-conflict-ours)", vim.tbl_extend("force", opts, { desc = "Use ours" }))
    map("n", "<leader>gmt", "<Plug>(git-conflict-theirs)", vim.tbl_extend("force", opts, { desc = "Use theirs" }))
    map("n", "<leader>gmb", "<Plug>(git-conflict-both)", vim.tbl_extend("force", opts, { desc = "Use both" }))
    map("n", "<leader>gmn", "<Plug>(git-conflict-none)", vim.tbl_extend("force", opts, { desc = "Use none" }))
    map(
      "n",
      "<leader>gmj",
      "<Plug>(git-conflict-next-conflict)",
      vim.tbl_extend("force", opts, { desc = "Next conflict" })
    )
    map(
      "n",
      "<leader>gmk",
      "<Plug>(git-conflict-prev-conflict)",
      vim.tbl_extend("force", opts, { desc = "Prev conflict" })
    )

    -- ✅ which-key new spec (2024+)
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>gm", group = "merge" },
        { "<leader>gmo", desc = "Use ours" },
        { "<leader>gmt", desc = "Use theirs" },
        { "<leader>gmb", desc = "Use both" },
        { "<leader>gmn", desc = "Use none" },
        { "<leader>gmj", desc = "Next conflict" },
        { "<leader>gmk", desc = "Prev conflict" },
      })
    end
  end,
}
