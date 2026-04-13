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

        vtsls = {
          keys = {
            { "<leader>ci", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports (TS)" },
            { "<leader>co", LazyVim.lsp.action["source.organizeImports.ts"],   desc = "Organize imports (TS)" },
            { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"],       desc = "Remove unused imports (TS)" },
          },
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
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
        -- Register missing vtsls client command handler to suppress the warning
        -- vtsls sends _typescript.didOrganizeImports after organizing imports,
        -- but Neovim has no built-in handler for it.
        vtsls = function(_, opts)
          Snacks.util.lsp.on({ name = "vtsls" }, function(_, client)
            client.commands["_typescript.didOrganizeImports"] = function() end
          end)
        end,

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
