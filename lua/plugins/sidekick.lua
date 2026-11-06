-- Move the ai.sidekick extra's <leader>a* keys under <leader>aS* so they don't
-- clash with claudecode.nvim / Copilot (<leader>aa, as, ad, af, av, ap, ...).
local old = { "aa", "as", "ad", "at", "af", "av", "ap", "ac" }

local function cli(fn)
  return function()
    require("sidekick.cli")[fn.name](fn.opts)
  end
end

return {
  "folke/sidekick.nvim",
  keys = function(_, keys)
    local drop = {}
    for _, k in ipairs(old) do
      drop["<leader>" .. k] = true
    end
    keys = vim.tbl_filter(function(k)
      return not drop[k[1]]
    end, keys)

    -- <C-.> can't be sent by iTerm2/tmux (no CSI u), replace with <M-.>
    keys = vim.tbl_filter(function(k)
      return k[1] ~= "<c-.>"
    end, keys)

    vim.list_extend(keys, {
      {
        "<M-.>",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      { "<leader>aS", "", desc = "+sidekick", mode = { "n", "x" } },
      { "<leader>aSa", cli({ name = "toggle" }), desc = "Sidekick Toggle CLI" },
      { "<leader>aSc", cli({ name = "toggle", opts = { name = "codex", focus = true } }), desc = "Sidekick Toggle Codex" },
      { "<leader>aSs", cli({ name = "select" }), desc = "Select CLI" },
      { "<leader>aSd", cli({ name = "close" }), desc = "Detach a CLI Session" },
      { "<leader>aSt", cli({ name = "send", opts = { msg = "{this}" } }), mode = { "n", "x" }, desc = "Send This" },
      { "<leader>aSf", cli({ name = "send", opts = { msg = "{file}" } }), desc = "Send File" },
      { "<leader>aSv", cli({ name = "send", opts = { msg = "{selection}" } }), mode = "x", desc = "Send Visual Selection" },
      { "<leader>aSp", cli({ name = "prompt" }), mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
    })
    return keys
  end,
}
