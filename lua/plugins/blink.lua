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
      opts.keymap["<C-j>"] = { "snippet_forward", "fallback" }
      opts.keymap["<C-k>"] = { "snippet_backward", "fallback" }
      opts.keymap["<C-e>"] = { "cancel", "fallback" }

      -- Scroll docs in completion popup
      opts.keymap["<C-f>"] = { "scroll_documentation_down", "fallback" }
      opts.keymap["<C-b>"] = { "scroll_documentation_up", "fallback" }

      -- Auto-show menu
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.auto_show = true

      -- Avoid accidental accepts
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = opts.completion.list.selection or {}
      opts.completion.list.selection.preselect = false

      -- Auto-show docs popup (like VSCode IntelliSense side panel)
      opts.completion.documentation = opts.completion.documentation or {}
      opts.completion.documentation.auto_show = true
      opts.completion.documentation.auto_show_delay_ms = 200
      opts.completion.documentation.window = { border = "rounded" }

      -- Signature help while typing function args (VSCode: see param name/type on each arg)
      opts.signature = {
        enabled = true,
        window = { border = "rounded", scrollbar = false },
      }

      return opts
    end,
  },
}
