-- IntelliJ-Darcula-style semantic highlighting for Java (jdtls semantic tokens).
-- Only applied on darcula-based colorschemes so other themes are untouched.
local M = {}

-- IntelliJ-like status bar: grey bar, blue/green/orange mode block
local function darcula_lualine_theme()
  local bar, panel, fg = "#3C3F41", "#4E5254", "#A9B7C6"
  local function mode(bg)
    return {
      a = { fg = "#FFFFFF", bg = bg, gui = "bold" },
      b = { fg = fg, bg = panel },
      c = { fg = fg, bg = bar },
    }
  end
  local theme = {
    normal = mode("#4B6EAF"),
    insert = mode("#6A8759"),
    visual = mode("#CC7832"),
    replace = mode("#BC3F3C"),
    command = mode("#BBB529"),
    inactive = { a = { fg = "#808080", bg = bar }, b = { fg = "#808080", bg = bar }, c = { fg = "#808080", bg = bar } },
  }
  theme.command.a.fg = "#2B2B2B"
  return theme
end

local function set_lualine(is_darcula)
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end
  local cfg = lualine.get_config()
  if not cfg or not cfg.options then
    return
  end
  local want = is_darcula and darcula_lualine_theme() or "auto"
  if is_darcula or type(cfg.options.theme) == "table" then
    cfg.options.theme = want
    lualine.setup(cfg)
  end
end

function M.apply()
  local name = (vim.g.colors_name or ""):lower()
  local is_darcula = name:find("darcula") ~= nil
  set_lualine(is_darcula)
  if not is_darcula then
    return
  end

  local c = {
    fg = "#A9B7C6",
    keyword = "#CC7832",
    method_decl = "#FFC66D",
    field = "#9876AA",
    annotation = "#BBB529",
    number = "#6897BB",
    type_param = "#20999D",
  }
  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Treesitter base (matches IntelliJ Darcula; LSP tokens below refine it)
  for _, g in ipairs({ "@variable", "@variable.member", "@variable.parameter", "@type", "@operator", "@function.method.call", "@module" }) do
    hi(g .. ".java", { fg = c.fg })
  end
  hi("@function.method.java", { fg = c.method_decl })
  hi("@constructor.java", { fg = c.fg })
  hi("@variable.member.java", { fg = c.field })
  hi("@attribute.java", { fg = c.annotation })
  hi("@keyword.operator.java", { fg = c.keyword })
  hi("@boolean.java", { fg = c.keyword })
  hi("@constant.builtin.java", { fg = c.keyword })
  hi("@punctuation.delimiter.java", { fg = c.keyword })
  hi("@type.builtin.java", { fg = c.keyword })
  hi("@string.java", { fg = "#6A8759" })

  -- jdtls tags keywords like public/static/final/class as "modifier" and package names as "namespace"
  hi("@lsp.type.modifier", { fg = c.keyword })
  hi("@lsp.type.keyword", { fg = c.keyword })
  hi("@lsp.type.namespace", { fg = c.fg })

  -- Types
  hi("@lsp.type.class", { fg = c.fg })
  hi("@lsp.type.interface", { fg = c.fg, italic = true })
  hi("@lsp.type.enum", { fg = c.fg })
  hi("@lsp.type.record", { fg = c.fg })
  hi("@lsp.type.typeParameter", { fg = c.type_param })
  hi("@lsp.type.annotation", { fg = c.annotation })
  hi("@lsp.typemod.class.abstract", { fg = c.fg, italic = true })

  -- Members
  hi("@lsp.type.method", { fg = c.fg })
  hi("@lsp.typemod.method.declaration", { fg = c.method_decl })
  hi("@lsp.typemod.method.static", { fg = c.fg, italic = true })
  hi("@lsp.typemod.method.abstract", { fg = c.fg, italic = true })
  hi("@lsp.typemod.method.deprecated", { fg = c.fg, strikethrough = true })
  hi("@lsp.type.property", { fg = c.field })
  hi("@lsp.typemod.property.static", { fg = c.field, italic = true })
  hi("@lsp.typemod.property.readonly", { fg = c.field, italic = true })
  hi("@lsp.type.enumMember", { fg = c.field, italic = true })

  -- Locals & params
  hi("@lsp.type.variable", { fg = c.fg })
  hi("@lsp.typemod.variable.readonly", { fg = c.fg })
  hi("@lsp.type.parameter", { fg = c.fg, underline = true })
end

M.apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- run after the colorscheme finishes so we override its @lsp.* links
    vim.schedule(M.apply)
  end,
})

-- The ColorScheme event is not reliably fired when the theme is switched from the
-- Java FileType hook, and jdtls semantic tokens arrive late, so re-apply on attach too.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      M.apply()
    end
  end,
})

return M
