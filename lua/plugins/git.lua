return {
  -- Inline hunks / blame
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        -- Navigation (use Vim convention)
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")

        -- Actions (leader g = git)
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")

        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>gq", "<cmd>diffoff | close<CR>", "Close diff window")

        -- Optional: quick diff
        map("n", "<leader>gd", gs.diffthis, "Diff this")
      end,
    },
  },

  -- Full-screen Git UI (optional but recommended)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Side-by-side diff / merge / file-history review inside Neovim
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (working tree)" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
    },
    opts = {
      enhanced_diff_hl = true, -- richer highlighting inside diffs
      view = {
        default = { layout = "diff2_horizontal" }, -- side-by-side
        merge_tool = { layout = "diff3_mixed" },
      },
    },
  },
}
