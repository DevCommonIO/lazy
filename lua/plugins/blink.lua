return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}

      -- Start from super-tab, then override the exact behavior
      opts.keymap.preset = "super-tab"

      -- Force VSCode-like behavior:
      -- - If completion menu is visible: Tab cycles, Enter confirms
      -- - If in snippet: Tab jumps forward/back
      -- - Otherwise: fallback (indent / tab)
      opts.keymap["<Tab>"] = { "select_next", "snippet_forward", "fallback" }
      opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
      opts.keymap["<CR>"] = { "accept", "fallback" }

      -- Make the menu appear automatically
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.auto_show = true

      -- Important for VSCode feel:
      -- preselect first item so Enter accepts immediately
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = opts.completion.list.selection or {}
      opts.completion.list.selection.preselect = true

      return opts
    end,
  },
}
