return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "super-tab"

      -- Completion navigation
      opts.keymap["<Tab>"] = { "select_next", "fallback" }
      opts.keymap["<S-Tab>"] = { "select_prev", "fallback" }
      opts.keymap["<CR>"] = { "accept", "fallback" }

      -- Snippet placeholder navigation (no Tab conflicts)
      opts.keymap["<C-j>"] = { "snippet_backward", "fallback" }
      opts.keymap["<C-k>"] = { "snippet_forward", "fallback" }
      opts.keymap["<C-e>"] = { "cancel", "hide", "fallback" }

      -- Auto-show menu
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.auto_show = true

      -- Avoid accidental accepts
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = opts.completion.list.selection or {}
      opts.completion.list.selection.preselect = false

      return opts
    end,
  },
}
