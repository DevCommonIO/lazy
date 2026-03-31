# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/). The plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim), bootstrapped in `lua/config/lazy.lua`.

## Architecture

### Entry Point
`init.lua` → `lua/config/lazy.lua` → loads LazyVim + all custom plugins from `lua/plugins/`

### Directory Structure
- `lua/config/` — core configuration loaded by LazyVim's bootstrap: `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`, `highlight-references.lua`
- `lua/plugins/` — each file returns a lazy.nvim plugin spec (or table of specs); all are auto-imported via `{ import = "plugins" }` in `lazy.lua`
- `lua/moonlucas/` — personal utility modules: `discipline.lua` (cowboy mode, currently disabled), `lsp.lua` (toggle helpers for inlay hints and autoformat), `hsl.lua`

### LazyVim Extras Enabled
See `lua/config/lazy.lua` for the full list. Key ones: TypeScript, Rust, JSON, Tailwind, ESLint, Prettier, Copilot, Copilot Chat, DAP (debug), Java, mini-hipatterns, VSCode compatibility.

### Key Plugin Choices
- **Colorscheme**: `solarized-osaka`
- **Completion**: `blink.cmp` (`vim.g.lazyvim_cmp = "blink.cmp"`) — Tab/S-Tab to navigate, CR to accept, C-j/C-k for snippet navigation
- **Picker**: Telescope (`vim.g.lazyvim_picker = "telescope"`)
- **AI**: GitHub Copilot + CopilotChat (model: `claude-sonnet-4.5`), keymaps under `<leader>C`
- **Shell**: fish

### Keymap Conventions
- Leader: `<Space>`
- Window ops: `s` prefix (`ss`=hsplit, `sv`=vsplit, `sh/sj/sk/sl`=focus, `sq`=close, `so`=only)
- Delete/change without yanking: `<leader>d`, `<leader>D`, `<leader>r`, `<leader>R`
- Paste from yank register: `<leader>p` / `<leader>P`
- Inlay hints toggle: `<leader>i`
- Inline diagnostics toggle: `<leader>ux`
- CopilotChat: `<leader>Ca` open, `<leader>Ct` toggle, `<leader>Cq` ask, `<leader>Cr` review buffer, `<leader>Cc` commit message

### Plugin File Conventions
Each file in `lua/plugins/` returns a table compatible with lazy.nvim specs. To override a LazyVim plugin, match by plugin name and use `opts`, `config`, or `keys` fields. The `lazyvim.json` file tracks which LazyVim extras are enabled via the LazyVim UI.

### Prettier
`vim.g.lazyvim_prettier_needs_config = true` — Prettier only runs when a config file is present in the project.

### Diagnostics
Virtual text is off by default; diagnostics float on `CursorHold` (500ms updatetime). Toggle inline text with `<leader>ux`.
