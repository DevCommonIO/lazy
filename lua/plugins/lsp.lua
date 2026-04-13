-- File: lua/plugins/lsp.lua
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- format / lint
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",

        -- LSP servers
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "yaml-language-server",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },

      -- Diagnostics behavior (virtual text + float popup)
      diagnostics = {
        underline = true,
        update_in_insert = false,
        severity_sort = true,

        -- keep or tweak; set to false if you want NO inline text
        virtual_text = false,
        virtual_lines = false,
        -- settings for :lua vim.diagnostic.open_float(...)
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
      },

      ---@type lspconfig.options
      servers = {
        cssls = {},
        html = {},

        yamlls = {
          settings = {
            yaml = { keyOrdering = false },
          },
        },

        tailwindcss = {
          root_dir = function(...)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.cjs",
              "postcss.config.mjs",
              "postcss.config.ts",
              "package.json",
              ".git"
            )(...)
          end,
        },

        ts_ls = {
          root_dir = function(...)
            local util = require("lspconfig.util")
            return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(...)
          end,
          single_file_support = false,
          on_attach = function(_, bufnr)
            -- Add missing imports
            vim.keymap.set("n", "<leader>ci", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
              })
            end, { buffer = bufnr, desc = "Add missing imports (TS)" })

            -- Organize / sort imports
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
              })
            end, { buffer = bufnr, desc = "Organize imports (TS)" })

            -- Remove unused imports
            vim.keymap.set("n", "<leader>cu", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
              })
            end, { buffer = bufnr, desc = "Remove unused imports (TS)" })
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { workspaceWord = true, callSnippet = "Both" },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = { privateName = { "^_" } },
              type = { castNumberToInteger = true },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = { strong = "Warning", strict = "Warning" },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = { enable = false },
            },
          },
        },
      },

      -- Hook into LazyVim's LSP attach flow
      setup = {
        -- ESLint: fix all auto-fixable issues (includes simple-import-sort)
        eslint = function(_, opts)
          opts.on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>ci", "<cmd>LspEslintFixAll<cr>",
              { buffer = bufnr, desc = "Fix imports (ESLint autofix)" })
          end
        end,

        -- runs for all servers
        ["*"] = function()
          vim.opt.updatetime = 500

          vim.diagnostic.config({
            float = {
              wrap = true,
              max_width = 100,
            },
          })

          local group = vim.api.nvim_create_augroup("DiagnosticFloatOnHover", { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = group,
            callback = function()
              vim.diagnostic.open_float(nil, {
                focus = false,
                scope = "cursor",
              })
            end,
          })

          vim.keymap.set("n", "<leader>ux", function()
            local cfg = vim.diagnostic.config()

            local vt_enabled = cfg.virtual_text ~= false
            local vl_enabled = cfg.virtual_lines == true

            local enable = not (vt_enabled or vl_enabled)

            vim.diagnostic.config({
              virtual_text = enable and { spacing = 2, prefix = "●" } or false,
              virtual_lines = false, -- keep OFF unless you want to toggle it too
            })
          end, { desc = "Toggle inline diagnostics text" })
        end,
      },
    },
  },
}
