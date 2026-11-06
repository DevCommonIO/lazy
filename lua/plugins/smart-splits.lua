-- Seamless navigation/resizing between Neovim splits and tmux panes.
-- Alt+h/j/k/l moves through nvim splits, then crosses into the neighbouring tmux
-- pane at the edge. Alt+arrows resize the same way. The tmux side lives in
-- ~/.tmux.conf (bindings check the @pane-is-vim option this plugin sets).
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- must load at startup so @pane-is-vim is set for tmux
  opts = {
    move = { at_edge = "stop" }, -- don't wrap around when there's no tmux pane either
  },
  keys = {
    { "<M-h>", function() require("smart-splits").move_cursor_left() end, mode = { "n", "t" }, desc = "Focus left split/pane" },
    { "<M-j>", function() require("smart-splits").move_cursor_down() end, mode = { "n", "t" }, desc = "Focus lower split/pane" },
    { "<M-k>", function() require("smart-splits").move_cursor_up() end, mode = { "n", "t" }, desc = "Focus upper split/pane" },
    { "<M-l>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "t" }, desc = "Focus right split/pane" },
    { "<M-Left>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
    { "<M-Down>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
    { "<M-Up>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
    { "<M-Right>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
  },
}
