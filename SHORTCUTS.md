# jk Neovim Shortcuts Reference

> Leader = `Space`

---

## Vim — Code Edition Essentials

### Motions

| Key | Description |
|-----|-------------|
| `w` / `W` | Next word start (word / WORD) |
| `e` / `E` | Next word end |
| `b` / `B` | Prev word start |
| `f{c}` / `F{c}` | Jump to next / prev char `c` on line |
| `t{c}` / `T{c}` | Jump before next / prev char `c` |
| `;` / `,` | Repeat last `f/t` forward / backward |
| `%` | Jump to matching bracket / paren |
| `{` / `}` | Prev / next empty line (paragraph) |
| `gg` / `G` | Top / bottom of file |
| `{n}G` | Go to line n |
| `H` / `M` / `L` | Top / middle / bottom of screen |
| `<C-d>` / `<C-u>` | Scroll half page down / up |
| `<C-o>` / `<C-m>` | Jump backward / forward in jumplist |
| `*` / `#` | Search word under cursor forward / backward |

### Operators + Text Objects

> Pattern: `{operator}{modifier}{object}` — e.g. `ci"`, `da{`, `yip`

| Operator | Description |
|----------|-------------|
| `d` | Delete |
| `c` | Change (delete + insert) |
| `y` | Yank (copy) |
| `v` | Visual select |
| `=` | Auto-indent |
| `>` / `<` | Indent / dedent |
| `gc` | Toggle comment (LazyVim) |

| Modifier | Description |
|----------|-------------|
| `i` | **i**nner (excludes delimiters) |
| `a` | **a**round (includes delimiters) |

| Object | Matches |
|--------|---------|
| `w` / `W` | word / WORD |
| `s` | sentence |
| `p` | paragraph |
| `"` `'` `` ` `` | string content |
| `(` `)` `b` | parentheses |
| `{` `}` `B` | curly braces |
| `[` `]` | square brackets |
| `<` `>` | angle brackets |
| `t` | HTML / XML tag |

**Examples:**

| Command | What it does |
|---------|-------------|
| `ciw` | Change word under cursor |
| `ci"` | Change content inside quotes |
| `ca{` | Change `{…}` block including braces |
| `da(` | Delete `(…)` including parens |
| `yi[` | Yank content inside `[…]` |
| `vip` | Select inner paragraph |
| `=ip` | Auto-indent inner paragraph |
| `>i{` | Indent block inside `{…}` |
| `gciw` | Toggle comment on word |
| `gcip` | Toggle comment on paragraph |

### Useful Operators in Normal Mode

| Key | Description |
|-----|-------------|
| `dd` / `yy` | Delete / yank current line |
| `D` / `Y` | Delete / yank to end of line |
| `cc` / `S` | Change entire line |
| `C` | Change to end of line |
| `>>` / `<<` | Indent / dedent current line |
| `==` | Auto-indent current line |
| `J` | Join line below onto current line |
| `u` / `<C-r>` | Undo / redo |
| `.` | Repeat last change |
| `~` | Toggle case of char under cursor |
| `gU{obj}` / `gu{obj}` | Uppercase / lowercase object |
| `xp` | Swap two characters (transpose) |

### Insert Mode

| Key | Description |
|-----|-------------|
| `I` / `A` | Insert at line start / end |
| `i` / `a` | Insert before cursor / after |
| `o` / `O` | New line below / above and insert |
| `gi` | Re-enter insert at last position |
| `<C-w>` | Delete word backward |
| `<C-u>` | Delete to start of line |
| `<C-r>{reg}` | Paste from register `{reg}` (e.g. `<C-r>"`) |

### Visual Mode

| Key | Description |
|-----|-------------|
| `v` / `V` / `<C-v>` | Char / line / block visual |
| `o` | Move to other end of selection |
| `gv` | Re-select last visual selection |
| `I` (block) | Insert at start of every selected line |
| `A` (block) | Append at end of every selected line |

### Search & Replace

| Key / Command | Description |
|---------------|-------------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / prev match |
| `cgn` | Change next match (repeat with `.`) |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace with confirmation |
| `:s/old/new/g` | Replace in selection / current line |
| `:%s/\<word\>/new/g` | Replace whole word only |

### Registers & Marks

| Key | Description |
|-----|-------------|
| `"ayy` | Yank line into register `a` |
| `"ap` | Paste from register `a` |
| `"+y` / `"+p` | Yank to / paste from system clipboard |
| `"0p` | Paste last explicit yank (not a delete) |
| `ma` | Set mark `a` at cursor |
| `` `a `` | Jump to exact position of mark `a` |
| `'a` | Jump to line of mark `a` |
| `:reg` | List all registers |

### Folds & Code Navigation

| Key | Description |
|-----|-------------|
| `za` | Toggle fold under cursor |
| `zM` / `zR` | Close / open all folds |
| `gd` | Go to definition (LSP) |
| `gD` | Go to declaration (LSP) |
| `gr` | Go to references (LSP) |
| `gi` | Go to implementation (LSP) |
| `K` | Hover documentation (LSP) |
| `[d` / `]d` | Prev / next diagnostic |

---

## Custom Editing (your config)

| Key | Mode | Description |
|-----|------|-------------|
| `jk` | insert | Exit insert mode |
| `x` | normal | Delete char (no yank) |
| `<leader>p` / `<leader>P` | n/v | Paste last yanked text after / before |
| `<leader>dw` | normal | Delete word under cursor (no yank) |
| `<leader>A` | normal | Select all |
| `<leader>o` / `<leader>O` | normal | New line below / above (no comment continuation) |
| `+` / `-` | normal | Increment / decrement number |
| `<A-J>` / `<A-K>` | n/v | Move line or selection down / up |
| `<C-m>` | normal | Jump forward (jumplist) |
| `<leader>id` | normal | Insert date heading (`## YYYY-MM-DD HH:MM`) |
| `<leader>xn` | normal | New timestamped scratch buffer (markdown) |

---

## Windows & Tabs

| Key | Mode | Description |
|-----|------|-------------|
| `ss` | normal | Horizontal split |
| `sv` | normal | Vertical split |
| `sh` / `sj` / `sk` / `sl` | normal | Focus left / down / up / right window |
| `sq` | normal | Close window |
| `so` | normal | Only window (close others) |
| `<M-←>` / `<M-→>` | normal | Resize window left / right |
| `<M-↑>` / `<M-↓>` | normal | Resize window up / down |
| `te` | normal | New tab |
| `<Tab>` / `<S-Tab>` | normal | Next / prev tab |

---

## Terminal (Claude CLI / DAP)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h/j/k/l>` | terminal | Navigate to adjacent window |
| `<Esc><Esc>` | terminal | Enter normal mode (to scroll/visual/yank) |
| `i` / `a` | normal | Return to terminal insert mode |

---

## Harpoon (file bookmarks)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ha` | normal | Add current file to harpoon |
| `<leader>hh` | normal | Open harpoon quick menu |
| `<C-h>` | normal | Jump to harpoon file 1 |
| `<C-j>` | normal | Jump to harpoon file 2 |
| `<C-k>` | normal | Jump to harpoon file 3 |
| `<C-n>` | normal | Jump to harpoon file 4 |

---

## Telescope / Search

| Key | Mode | Description |
|-----|------|-------------|
| `;f` | normal | Find files (respects .gitignore) |
| `;g` | normal | Git files (+ untracked) |
| `;r` | n/v | Live grep — word under cursor / visual selection |
| `;b` | n/v | Fuzzy search current buffer — word / selection |
| `;s` | normal | LSP document symbols |
| `;w` | normal | Diagnostics (workspace) |
| `;x` | normal | Diagnostics (current buffer) |
| `;t` | normal | Help tags |
| `;;` | normal | Resume previous picker |
| `\\` | normal | List open buffers |
| `<leader>fP` | normal | Find plugin file |
| `<leader>sr` | normal | Search & Replace across project (grug-far) |

---

## Completion (blink.cmp)

| Key | Mode | Description |
|-----|------|-------------|
| `<Tab>` / `<S-Tab>` | insert | Next / prev completion item |
| `<CR>` | insert | Accept completion |
| `<C-j>` / `<C-k>` | insert | Snippet jump forward / backward |
| `<C-e>` | insert | Cancel completion |
| `<C-f>` / `<C-b>` | insert | Scroll docs down / up |

---

## Copilot

| Key | Mode | Description |
|-----|------|-------------|
| `<C-l>` | insert | Accept suggestion |
| `<C-Right>` | insert | Accept next word |
| `<C-Down>` | insert | Accept full line |
| `<C-]>` / `<C-[>` | insert | Next / prev suggestion |
| `<C-;>` | insert | Dismiss suggestion |
| `<leader>ap` | normal | Toggle Copilot auto-trigger |

---

## CopilotChat

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>Ca` | n/v | Open chat |
| `<leader>Ct` | n/v | Toggle chat |
| `<leader>Cq` | n/v | Ask (prefills selection if visual) |
| `<leader>Cb` | n/v | Insert `#buffer:active` in chat |
| `<leader>CS` | n/v | Insert `#selection` in chat |
| `<leader>CB` | n/v | Add all open buffers as `#file` |
| `<leader>Cr` | normal | Review current buffer |
| `<leader>Ce` | visual | Explain selection |
| `<leader>Cc` | normal | Generate commit message (staged diff) |
| `<leader>Cx` | n/v | Reset chat |

---

## Claude Code CLI

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ac` | normal | Toggle Claude terminal |
| `<leader>af` | normal | Focus Claude terminal |
| `<leader>ar` | normal | Resume last session |
| `<leader>aC` | normal | Continue last session |
| `<leader>ab` | normal | Add current buffer to context |
| `<leader>as` | visual | Send selection to Claude |
| `<leader>aa` | normal | Accept diff & return to Claude terminal |
| `<leader>ad` | normal | Deny diff |
| `<leader>ah` | normal | Move Claude terminal to bottom (horizontal) |
| `<leader>av` | normal | Move Claude terminal to right (vertical) |

---

## Git

| Key | Mode | Description |
|-----|------|-------------|
| `]h` / `[h` | normal | Next / prev hunk |
| `<leader>gs` | n/v | Stage hunk / selection |
| `<leader>gr` | n/v | Reset hunk / selection |
| `<leader>gS` | normal | Stage entire buffer |
| `<leader>gR` | normal | Reset entire buffer |
| `<leader>gp` | normal | Preview hunk |
| `<leader>gb` | normal | Toggle line blame |
| `<leader>gd` | normal | Diff this |
| `<leader>gq` | normal | Close diff window |
| `<leader>gg` | normal | Open LazyGit |

---

## Debug (DAP)

| Key | Mode | Description |
|-----|------|-------------|
| `<F5>` | normal | Start / Continue |
| `<F8>` | n/i/t | Stop session |
| `<F10>` | normal | Step over |
| `<F11>` | normal | Step into |
| `<F12>` | normal | Step out |
| `<leader>db` | normal | Toggle breakpoint |
| `<leader>dB` | normal | Conditional breakpoint |
| `<leader>dr` | normal | Open REPL |
| `<leader>dl` | normal | Run last config |
| `<leader>du` | normal | Toggle DAP UI |
| `<leader>dx` | normal | Stop (keep UI) |
| `<leader>dtm` | normal | Debug: Python test method |
| `<leader>dtc` | normal | Debug: Python test class |
| `<leader>dtf` | normal | Debug: Jest current file |
| `<leader>dta` | normal | Debug: Jest all tests |

---

## Coding Utilities

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>m` | normal | Toggle split / join block (treesj) |
| `<C-a>` / `<C-x>` | n/v | Increment / decrement (booleans, hex, semver, let↔const) |
| `[n` / `]n` | normal | Prev / next treesitter node (mini.bracketed) |
| `<leader>i` | normal | Toggle inlay hints |
| `<leader>ux` | normal | Toggle inline diagnostics |
| `<leader>z` | normal | Zen mode |

### Refactoring (refactoring.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>re` | n/v | Open refactor picker |
| `<leader>rf` | visual | Extract selection to function |
| `<leader>rv` | visual | Extract selection to variable |
| `<leader>ri` | n/v | Inline variable |

