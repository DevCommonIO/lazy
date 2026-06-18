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

  -- Darcula — IntelliJ IDEA default dark theme
  {
    "xiantang/darcula-dark.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Neodarcula — IntelliJ newer dark theme with transparency support
  {
    "pmouraguedes/neodarcula.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Java / JetBrains-IDE themes are exposed under custom `java-*` names via thin
  -- alias files in `colors/` (so they group together in the picker). They reuse
  -- the plugins above — no extra dependencies:
  --   java-darcula         → darcula-dark   (classic IntelliJ IDEA Darcula)
  --   java-darcula-solid   → darcula-solid  (high-contrast Darcula)
  --   java-darcula-darker  → darcula-darker (deeper background)
  --   java-darcula-new     → neodarcula     (IntelliJ "New UI" dark)
  --   java-dracula         → dracula        (Dracula palette)
  --   java-light           → catppuccin-latte (IntelliJ Light feel)

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