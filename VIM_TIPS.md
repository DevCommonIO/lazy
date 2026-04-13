# Neovim Workflow Tips

## Use `<C-o>` for one quick Normal mode command

`<C-o>` lets you execute **one** Normal mode command from Insert mode, then returns to Insert mode.

Best use cases:
- quick movement
- opening a line above/below
- jumping to match/end of line
- a single paste/put action

| Instead of...              | Use              |
|---------------------------|------------------|
| `Esc` → `O` → (insert)    | `<C-o>O`         |
| `Esc` → `o` → (insert)    | `<C-o>o`         |
| `Esc` → `p` → `i`         | `<C-o>p`         |
| `Esc` → `A`               | `<C-o>A`         |
| `Esc` → `%`               | `<C-o>%`         |
| `Esc` → `$`               | `<C-o>$`         |
| `Esc` → `dd` → `i`        | `<C-o>dd`        |
| `Esc` → `u` (undo) → `i`  | `<C-o>u`         |

> Use `<C-o>` for a single quick action. If you need multiple Normal mode steps, just leave Insert mode normally.

---

## Insert register contents without leaving Insert mode

| Key         | What it does                             |
|-------------|------------------------------------------|
| `<C-r>"`    | Insert from unnamed register             |
| `<C-r>0`    | Insert last yank (safe)                  |
| `<C-r>+`    | Insert from system clipboard             |
| `<C-r>-`    | Insert last small delete                 |

> Prefer `<C-r>0` when you want the last yanked text. The unnamed register `"` may be overwritten by deletes.

---

## Insert mode editing without Esc

| Key       | What it does                          |
|-----------|---------------------------------------|
| `<C-w>`   | Delete word backwards                 |
| `<C-u>`   | Delete to beginning of line           |
| `<C-h>`   | Delete one character back             |
| `<C-t>`   | Indent current line                   |
| `<C-d>`   | De-indent current line                |

---

## Faster ways to leave Insert mode

| Key       | What it does                                    |
|-----------|-------------------------------------------------|
| `<C-[>`   | Same as `Esc` — easier to reach                 |
| `<C-c>`   | Exit insert (skips `InsertLeave` autocmds — avoid) |
| `jk`      | Optional remap for `Esc` — add to keymaps.lua  |

---

## Navigation inside Insert mode

| Key        | What it does        |
|------------|---------------------|
| `<C-o>b`   | Back one word       |
| `<C-o>w`   | Forward one word    |
| `<C-o>^`   | First non-blank     |
| `<C-o>$`   | End of line         |
| `<C-o>%`   | Matching pair       |

---

## React / JSX Real Patterns

### Close fragments efficiently

❌ Slow
```
type <>
Esc → } → i → type </>
```

✅ Better
```
type <>
<C-o>A
type </>
```

> Prefer local movement (`$`, `A`, `%`) instead of jumping with `}`.

---

### Avoid using `}` as default navigation

| Intent                 | Use instead     |
|-----------------------|-----------------|
| End of line           | `$` / `A`       |
| Matching pair         | `%`             |
| Next closing brace    | `]}`            |
| Precise movement      | `f`, `t`        |

---

### Paste + continue typing

❌ Slow
```
Esc → p → i
```

✅ Better
```
<C-r>0
```

> After `p` in Normal mode, use `a`, `A`, or `o` instead of `i` to re-enter insert at the right position.

---

### Stop overusing `i`

| Situation           | Better key |
|--------------------|------------|
| After cursor        | `a`        |
| End of line         | `A`        |
| New line below      | `o`        |
| New line above      | `O`        |

> `i` = insert **before** cursor. Use it intentionally.

---

### Create lines instead of navigating

❌ Slow
```
Esc → move → i
```

✅ Better
```
o   (new line below)
O   (new line above)
```

---

### JSX tag text objects (Treesitter)

| Key    | What it does                  |
|--------|-------------------------------|
| `vat`  | Select around tag             |
| `vit`  | Select inside tag             |
| `dat`  | Delete around tag             |
| `dit`  | Delete tag, keep content      |
| `cat`  | Change around tag             |
| `cit`  | Change inside tag             |

> Requires treesitter textobjects (included in LazyVim).

---

## Function / block navigation (Treesitter)

| Key   | What it does          |
|-------|-----------------------|
| `]m`  | Next function start   |
| `[m`  | Prev function start   |
| `]M`  | Next function end     |
| `[M`  | Prev function end     |
| `]}`  | Next closing brace    |
| `[{`  | Prev opening brace    |

---

## Mode Decision Guide

| Situation                   | Best approach     |
|-----------------------------|-------------------|
| One quick action            | `<C-o>`           |
| Multiple edits/movements    | `Esc`             |
| Typing flow                 | Stay in Insert    |
| Structural change           | Normal mode       |

> Optimize for fewer **total** actions, not fewer `Esc`.

---

## Mode Thrashing Warning

If you find yourself doing:
```
Esc → i
Esc → i
Esc → i
```

Fix by asking:
- Should this be `a`, `A`, `o`, or `O`?
- Should I use `<C-o>`?
- Am I using the wrong motion?

---

## Golden Rules

- Prefer precise motion over large jumps
- Use the correct insert command (`a`, `A`, `o`, `O`)
- Use `<C-o>` for one action only
- Use Normal mode for multi-step edits
- Let plugins handle repetitive JSX work (ts-autotag, treesitter)
