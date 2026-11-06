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
        map("n", "<leader>ga", gs.stage_hunk, "Stage hunk (git add)")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>ga", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")

        map("n", "<leader>gA", gs.stage_buffer, "Stage buffer")
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
      { "<leader>gf", "<cmd>DiffviewOpen -- %<cr>", desc = "Diffview: current file vs HEAD (working tree)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },

      -- Code review: this branch vs where it forked off the base branch.
      -- Uses `base...HEAD` (three dots = merge base), so you see only what the
      -- branch changed, not unrelated commits that landed on the base since.
      {
        "<leader>gc",
        function()
          require("moonlucas.git").review()
        end,
        desc = "Review: branch vs base (merge base)",
      },
      {
        "<leader>gC",
        function()
          require("moonlucas.git").review({ prompt = true })
        end,
        desc = "Review: branch vs base (pick base)",
      },
      {
        "<leader>gL",
        function()
          require("moonlucas.git").review({ log = true })
        end,
        desc = "Review: commits on this branch",
      },
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
