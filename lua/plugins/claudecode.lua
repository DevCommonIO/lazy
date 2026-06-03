return {
  "coder/claudecode.nvim",
  opts = {
    diff_opts = {
      open_in_new_tab = true,
      keep_terminal_focus = true,
    },
  },
  keys = {
    -- Accept diff and return focus to Claude terminal
    {
      "<leader>aa",
      function()
        local cur = vim.api.nvim_get_current_buf()
        local diff_buf = vim.b[cur].claudecode_diff_tab_name and cur
        local tab_name = vim.b[cur].claudecode_diff_tab_name
        if not tab_name then
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(b) and vim.b[b].claudecode_diff_tab_name then
              diff_buf, tab_name = b, vim.b[b].claudecode_diff_tab_name
              break
            end
          end
        end
        if not tab_name then
          vim.notify("No active Claude diff found", vim.log.levels.WARN)
          return
        end
        require("claudecode.diff")._resolve_diff_as_saved(tab_name, diff_buf)
        vim.schedule(function()
          local t = require("claudecode.terminal")
          local buf = t.get_active_terminal_bufnr and t.get_active_terminal_bufnr()
          local win = buf and vim.fn.bufwinid(buf)
          if win and win ~= -1 then
            vim.api.nvim_set_current_win(win)
            vim.cmd("startinsert")
          end
        end)
      end,
      desc = "Accept diff & return to Claude terminal",
    },

    -- Reposition Claude terminal layout
    {
      "<leader>ah",
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_get_name(buf):lower():find("claude") then
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
              vim.api.nvim_win_close(win, false)
            end
            vim.cmd("botright split")
            vim.api.nvim_set_current_buf(buf)
            vim.cmd("startinsert")
            return
          end
        end
        vim.notify("Claude terminal not found", vim.log.levels.WARN)
      end,
      desc = "Claude → bottom (horizontal)",
    },
    {
      "<leader>av",
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_get_name(buf):lower():find("claude") then
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
              vim.api.nvim_win_close(win, false)
            end
            vim.cmd("botright vsplit")
            vim.api.nvim_set_current_buf(buf)
            vim.cmd("startinsert")
            return
          end
        end
        vim.notify("Claude terminal not found", vim.log.levels.WARN)
      end,
      desc = "Claude → right (vertical)",
    },
  },
}
