-- File: lua/plugins/ui.lua
return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}

      -- skip noisy notification
      table.insert(opts.routes, {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      })

      -- send notifications to OS when unfocused
      local aug = vim.api.nvim_create_augroup("NoiceFocusRoutes", { clear = true })
      local focused = true

      vim.api.nvim_create_autocmd("FocusGained", {
        group = aug,
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        group = aug,
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = opts.commands or {}
      opts.commands.all = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = aug,
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            local ok, md = pcall(require, "noice.text.markdown")
            if ok and md and md.keys then
              md.keys(event.buf)
            end
          end)
        end,
      })

      opts.presets = opts.presets or {}
      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}

      -- append pretty_path safely
      table.insert(
        opts.sections.lualine_c,
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        })
      )
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}
