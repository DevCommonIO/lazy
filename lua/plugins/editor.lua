-- File: lua/plugins/editor.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    keys = {
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
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = false,
          })
        end,
        desc = "Find files (respects .gitignore)",
      },
      -- Current buffer search (fuzzy find)
      {
        ";b",
        function()
          local builtin = require("telescope.builtin")

          local mode = vim.fn.mode()
          if mode:match("[vV\22]") then
            -- Use visual selection as initial query
            local bufnr = 0
            local start = vim.api.nvim_buf_get_mark(bufnr, "<")
            local finish = vim.api.nvim_buf_get_mark(bufnr, ">")

            local srow, scol = start[1] - 1, start[2]
            local erow, ecol = finish[1] - 1, finish[2]
            if srow > erow or (srow == erow and scol > ecol) then
              srow, erow = erow, srow
              scol, ecol = ecol, scol
            end

            local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol + 1, {})
            local selection =
              table.concat(lines, "\n"):gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

            builtin.current_buffer_fuzzy_find({
              default_text = selection,
              previewer = false,
            })
          else
            -- Normal mode: prefill with word under cursor
            builtin.current_buffer_fuzzy_find({
              default_text = vim.fn.expand("<cword>"),
              previewer = false,
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
            -- Visual selection -> default_text
            local function get_visual_selection()
              local bufnr = 0
              local start = vim.api.nvim_buf_get_mark(bufnr, "<")
              local finish = vim.api.nvim_buf_get_mark(bufnr, ">")

              local srow, scol = start[1] - 1, start[2]
              local erow, ecol = finish[1] - 1, finish[2]

              if srow > erow or (srow == erow and scol > ecol) then
                srow, erow = erow, srow
                scol, ecol = ecol, scol
              end

              local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol + 1, {})
              local text = table.concat(lines, "\n")
              return text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
            end

            local selection = get_visual_selection()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

            builtin.live_grep({
              default_text = selection,
              additional_args = function()
                return rg_args()
              end,
            })
          else
            -- Normal mode -> word under cursor
            local word = vim.fn.expand("<cword>")
            builtin.live_grep({
              default_text = word,
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
          })
        end,
        desc = "Diagnostics (workspace)",
      },
      -- Diagnostics (current buffer)
      {
        ";x",
        function()
          require("telescope.builtin").diagnostics({
            bufnr = 0,
            initial_mode = "normal",
            theme = "ivy",
          })
        end,
        desc = "Diagnostics (current buffer)",
      },

      -- Symbols: Treesitter if available, else LSP symbols
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          if builtin.treesitter then
            builtin.treesitter()
          else
            builtin.lsp_document_symbols({ symbol_width = 50, show_line = false })
          end
        end,
        desc = "Symbols (Treesitter / LSP fallback)",
      },
    },

    config = function(_, opts)
      local telescope = require("telescope")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
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
    end,
  },
}
