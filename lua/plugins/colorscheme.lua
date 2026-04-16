return {
  {
    "craftzdog/solarized-osaka.nvim",
    branch = "osaka",
    lazy = true,
    priority = 1000,
    opts = { transparent = true },
  },

  -- Catppuccin — warm, four variants: latte (light), frappe, macchiato, mocha (darkest)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "mocha", -- latte | frappe | macchiato | mocha
    },
  },

  -- Rose Pine — minimal, muted palette. variants: main, moon, dawn (light)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    opts = {
      variant = "moon", -- auto | main | moon | dawn
      disable_background = true,
    },
  },

  -- Kanagawa — dark Japanese-inspired, great contrast for JSX
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "wave", -- wave | dragon | lotus
    },
  },

  -- Telescope picker to preview & switch live
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>uC",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Switch colorscheme (preview)",
      },
    },
  },
}