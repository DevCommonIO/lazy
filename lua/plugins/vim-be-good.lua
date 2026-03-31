return {
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    keys = {
      { "<leader>T", group = "training" },

      { "<leader>Tv", "<cmd>VimBeGood<cr>", desc = "VimBeGood" },

      -- Optional quick training modes
      { "<leader>Tw", "<cmd>VimBeGood word<cr>", desc = "Train words" },
      { "<leader>Tm", "<cmd>VimBeGood motion<cr>", desc = "Train motions" },
    },
  },
}
