-- File: lua/plugins/editor.lua
return {
  -- File bookmarking — jump to marked files instantly
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<C-n>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
    },
    config = true,
  },

  -- Project-wide search & replace
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search & Replace (project)" },
    },
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },

    keys = (function()
      local function get_visual_selection()
        local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
        local text = table.concat(lines, "\n")
        return text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
      end

      return {
      -- Find plugin files
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },

      -- Files
      {
        ";f",
        function()
          local mode = vim.fn.mode()
          local opts = { hidden = true, no_ignore = false }
          if mode:match("[vV\22]") then
            local selection = get_visual_selection()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            opts.default_text = selection
          end
          require("telescope.builtin").find_files(opts)
        end,
        mode = { "n", "v" },
        desc = "Find files (respects .gitignore)",
      },
      -- Current buffer search (fuzzy find)
      {
        ";b",
        function()
          local builtin = require("telescope.builtin")

          local mode = vim.fn.mode()
          if mode:match("[vV\22]") then
            local selection = get_visual_selection()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

            builtin.current_buffer_fuzzy_find({
              default_text = selection,
              previewer = true,
              initial_mode = "insert",
              sorting_strategy = "ascending",
              layout_config = {
                prompt_position = "top",
              },
            })
          else
            builtin.current_buffer_fuzzy_find({
              default_text = vim.fn.expand("<cword>"),
              previewer = true,
              initial_mode = "insert",
              sorting_strategy = "ascending",
              layout_config = {
                prompt_position = "top",
              },
            })
          end
        end,
        mode = { "n", "v" },
        desc = "Buffer search (word/selection)",
      },
      -- Grep (normal): word under cursor. Grep (visual): selection.
      {
        ";r",
        function()
          local builtin = require("telescope.builtin")

          local function rg_args()
            return {
              "--hidden",
              "--glob",
              "!.git/*",
              "--glob",
              "!**/node_modules/*",
              "--glob",
              "!**/dist/*",
              "--glob",
              "!**/.next/*",
              "--glob",
              "!**/target/*",
              "--glob",
              "!**/.venv/*",
            }
          end

          local mode = vim.fn.mode()
          if mode:match("[vV\22]") then
            local selection = get_visual_selection()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

            builtin.live_grep({
              default_text = selection,
              additional_args = function()
                return rg_args()
              end,
            })
          else
            builtin.live_grep({
              default_text = vim.fn.expand("<cword>"),
              additional_args = function()
                return rg_args()
              end,
            })
          end
        end,
        mode = { "n", "v" },
        desc = "Live Grep (word/selection)",
      },

      -- Resume previous picker
      {
        ";;",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume previous Telescope picker",
      },

      -- Buffers
      {
        "\\\\",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "List open buffers",
      },

      -- Help
      {
        ";t",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help tags",
      },
      {
        ";w",
        function()
          require("telescope.builtin").diagnostics({
            initial_mode = "normal",
            theme = "ivy",
            sorting_strategy = "ascending",
            layout_config = {
              prompt_position = "top",
              preview_cutoff = 0, -- always show preview
            },
            previewer = true, -- 🔑 enables the right-side preview
          })
        end,
        desc = "Diagnostics (workspace)",
      },
      -- Diagnostics (current buffer) — opens in Trouble so you can yank messages
      {
        ";x",
        function()
          require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
        end,
        desc = "Diagnostics (current buffer)",
      },
      -- LSP document symbols
      {
        ";s",
        function()
          local mode = vim.fn.mode()
          local opts = { symbol_width = 50, show_line = true }
          if mode:match("[vV\22]") then
            local selection = get_visual_selection()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            opts.default_text = selection
          end
          require("telescope.builtin").lsp_document_symbols(opts)
        end,
        mode = { "n", "v" },
        desc = "Symbols (LSP)",
      },

      -- Git-tracked files (fast project navigation)
      {
        ";g",
        function()
          require("telescope.builtin").git_files({ show_untracked = true })
        end,
        desc = "Git files",
      },
      }
    end)(),

    config = function(_, opts)
      local telescope = require("telescope")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = false,
        path_display = { "filename_first" },
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      })

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      })

      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      vim.keymap.set("n", "<leader>uw", function()
        local wrapped = opts.defaults.wrap_results
        opts.defaults.wrap_results = not wrapped
        opts.defaults.path_display = wrapped and { "filename_first" } or false
        telescope.setup(opts)
        vim.notify("Telescope results: " .. (opts.defaults.wrap_results and "wrap (full path)" or "filename first (one line)"))
      end, { desc = "Toggle Telescope result wrapping" })
    end,
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },
}
