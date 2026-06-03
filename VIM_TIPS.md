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

### Example

```
function App() {           ← [m from anywhere below jumps here
  const [count, setCount] = useState(0);

  function handleClick() { ← ]m from above jumps here
    setCount(count + 1);
  }                        ← ]M jumps to this closing brace

  return <div>...</div>;
}                          ← ]} from inside jumps to this closing brace
```

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

## The `cgn` Pattern — Replace Word by Word with `.`

The single most powerful rename workflow in Vim. No `:s`, no multi-cursor.

```
*        → search word under cursor (highlights all occurrences)
cgn      → change the next match
type replacement
Esc
.        → repeat on next match (skip with n)
```

| Step | What happens |
|------|-------------|
| `*` | Search word under cursor, jump to next match |
| `cgn` | Change the **g**lobally **n**ext match (operator + motion) |
| `.` | Repeat the exact same change on next match |
| `n` | Skip one match without changing |

> This is selective find-and-replace with zero commands to memorize beyond `*`, `cgn`, `.`

### Example: rename a variable

```
// cursor on "count" in line 1
const count = 0;          ← cursor here on "count"
setCount(count + 1);
console.log(count);

*                         ← highlights all "count", jumps to next
N                         ← back to first "count"
cgn                       ← deletes "count", enters insert mode
total                     ← type replacement
Esc
.                         ← next "count" → "total"
.                         ← next "count" → "total"

// result:
const total = 0;
setTotal(total + 1);      ← wait, setCount needs manual fix — skip with n
console.log(total);
```

### Variations

| Pattern | Use case |
|---------|----------|
| `*Ncgn` | `*` jumps forward — `N` goes back to the word you were on, `cgn` changes it first |
| `#cgn` | Same but search backward first |
| `gncgn` | When you're already on a search match and want to change it |

---

## Operators + Search Motion — Delete/Change Up To a Pattern

Operators (`d`, `c`, `y`, `v`) work with `/` and `?` as motions:

| Command | What it does |
|---------|-------------|
| `d/return` | Delete from cursor up to (not including) "return" |
| `c/}` | Change from cursor up to next `}` |
| `y/function` | Yank from cursor up to "function" |
| `v/TODO` | Visual select up to "TODO" |
| `d?import` | Delete backward to "import" |

> These are incredibly powerful for deleting/changing irregular chunks of code that don't fit a text object.

### Real examples

```
// cursor on "fetch"
const result = fetch(url).then(res => res.json());

d/\.then    → deletes "fetch(url)" — leaves ".then(res => res.json());"
```

```
// cursor at start of line
  return calculateTotal(items, tax, discount);

c/);        → clears everything up to ");" — type new expression, ";" stays
```

```
// cursor on "old"
<div className="old stale">content</div>

d/<\/div>   → deletes everything from "old" up to "</div>"
```

---

## Precise Line Navigation

### Horizontal — stop using `w` for everything

| Key | When to use |
|-----|-------------|
| `f{c}` | Jump **to** a character you can see — fastest for known targets |
| `t{c}` | Jump **before** a character — perfect before `d`, `c` operators |
| `;` / `,` | Repeat last `f`/`t` forward / backward |
| `0` / `^` | Start of line / first non-blank |
| `$` | End of line |
| `w` / `b` | Word-level hops when target is 2-3 words away |
| `W` / `B` | WORD hops — skip past punctuation (dots, arrows, colons) |
| `e` | End of word — useful before `a` to append after a word |

**f/t with operators — the killer combo:**

| Command | What it does |
|---------|-------------|
| `dt)` | Delete up to `)` |
| `cf,` | Change up to and including `,` |
| `yt:` | Yank up to `:` |
| `df.` | Delete up to and including `.` |
| `vt"` | Visual select up to `"` |

> Think: "I want to **d**elete un**t**il the closing paren" → `dt)`

### Examples

```
// cursor on "first" — want to delete first param
doSomething(first, second, third)

dt,         → doSomething(, second, third)      delete up to comma
x           → doSomething( second, third)       remove comma
```

```
// cursor on "old" — want to replace up to the colon
const old_value: string = "hello";

ct:         → const |: string = "hello";        type new name
newValue    → const newValue: string = "hello";
```

```
// cursor on "user" — want to change the method name
user.getFullName().trim()

f.          → jump to first "."
lct(        → change "getFullName" → type new method
display     → user.display().trim()
```

### Vertical — jump by structure, not by line

| Key | What it does |
|-----|-------------|
| `}` / `{` | Next / prev blank line (paragraph boundary) |
| `]m` / `[m` | Next / prev function/method start |
| `]]` / `[[` | Next / prev section (top-level `{`) |
| `]}` / `[{` | Next closing / prev opening brace at same depth |
| `%` | Matching bracket/paren/brace |
| `gd` | Go to definition → `<C-o>` to come back |
| `gr` | Go to references |
| `;s` | LSP symbols — jump to any function/type in the file |

---

## Visual Select → Search/Replace Workflows

### Select then search project-wide

```
// cursor on "fetchUser" — where else is it used?
const data = fetchUser(id);

viw      → select "fetchUser"
;r       → Telescope live grep opens with "fetchUser" pre-filled
         → see every file that references it
```

Works with any visual selection, not just words:

```
// want to find everywhere this error message appears
throw new Error("Invalid session token");

vi"      → select "Invalid session token"
;r       → grep for that exact string across the project
```

```
// want to find this JSX pattern in the current file
<Button variant="primary">

vat      → select the entire <Button> tag
;b       → fuzzy find it in current buffer
```

### Select then search & replace

```
// rename "userId" across the whole project
const userId = params.id;

viw         → select "userId"
;r          → review all files using it (make sure rename is safe)
<Esc>
<leader>sr  → open grug-far → type userId → accountId → replace all
```

### Search current word without jumping

`*` jumps to the next match. If you just want to highlight:

```
// cursor on "enabled" — just want to see where it appears
const enabled = config.featureFlag;

*N       → highlights all "enabled" in file, cursor stays put
```

Or use `#` which searches backward (stays closer to where you are).

---

## The Dot Repeat Mindset

`.` repeats the **last change**. Structure edits so they're repeatable:

### Good (repeatable)

| Action | Then `.` does |
|--------|--------------|
| `ciw` new_name `Esc` | Changes next word to "new_name" (with `n.`) |
| `A;` `Esc` | Appends `;` at end of line |
| `I// ` `Esc` | Prepends `// ` at start of line |
| `da(` | Deletes next `(…)` block |
| `ct,` replacement `Esc` | Changes up to next `,` |

### Example: add semicolons to multiple lines

```
const a = 1        ← cursor here
const b = 2
const c = 3

A;       → const a = 1;     (append ";" at end)
Esc
j.       → const b = 2;     (down one line, repeat)
j.       → const c = 3;     (again)
```

### Example: comment out scattered lines

```
// cursor on a line you want to comment
const debug = true;

I// Esc  → // const debug = true;
         → now jump to any other line and press . to comment it too
```

### Bad (not repeatable)

| Action | Why |
|--------|-----|
| `lllllx` | Multiple motions before action |
| `v` → extend → `d` | Visual mode breaks dot-repeat |
| `3dw` | Count makes it too specific |

> The pattern: **one motion + one operator = one repeatable action**. Then `n.` or `j.` to apply it down the file.

---

## Quick Replace Patterns

| Pattern | Use case |
|---------|----------|
| `ciw` | Replace the word under cursor |
| `ci"` / `ci'` | Replace string contents |
| `ci(` / `ci{` / `ci[` | Replace inside brackets |
| `cit` | Replace inside HTML/JSX tag |
| `C` | Replace from cursor to end of line |
| `cc` / `S` | Replace entire line |
| `ct{c}` | Replace up to character `{c}` |
| `cf{c}` | Replace up to and including `{c}` |

### Examples

```
// cursor anywhere on "hello"
const msg = "hello world";

ciw       → const msg = "|world";           replace one word
ci"       → const msg = "|";                replace string contents
ci(       → not applicable here, but...
```

```
// cursor inside the parens
calculatePrice(100, 0.2, true)

ci(       → calculatePrice(|)               clear all args, type new ones
```

```
// cursor on "Click"
<Button onClick={handler}>Click me</Button>

cit       → <Button onClick={handler}>|</Button>   replace tag content
```

### Method/function patterns

```
// cursor on "get" — rename the function
const user = getUser(id);

f(        → cursor on "("
bcw       → cursor on "get|User", change word
fetch     → const user = fetchUser(id);
```

```
// cursor on line — change all arguments
sendEmail("old@mail.com", "subject", body);

f(        → jump to "("
ci(       → sendEmail(|);                    type new args
"new@mail.com", "updated", content
          → sendEmail("new@mail.com", "updated", content);
```

```
// cursor on "user" — change the method name
user.getFullName().trim()

f.lct(    → user.|(). trim()                type new method
toString  → user.toString().trim()
```

```
// cursor on line — delete middle parameter
render(App, container, options);

f,        → jump to first ","
df,       → render(App, options);           deleted ", container"
```

---

## Surround Operations (mini.surround)

LazyVim includes mini.surround — change/add/delete surrounding chars:

| Command | What it does |
|---------|-------------|
| `gsa{obj}{char}` | **Add** surround — e.g. `gsaiw"` wraps word in `"` |
| `gsd{char}` | **Delete** surround — e.g. `gsd"` removes surrounding `"` |
| `gsr{old}{new}` | **Replace** surround — e.g. `gsr"'` changes `"` to `'` |

> LazyVim uses the `gs` prefix to avoid conflict with flash.nvim's `s`.

### Real examples

| Before | Command | After |
|--------|---------|-------|
| `hello` | `gsaiw"` | `"hello"` |
| `"hello"` | `gsr"'` | `'hello'` |
| `(x + y)` | `gsd(` | `x + y` |
| `<div>text</div>` | `gsdt` + type `span>` | `<span>text</span>` |
| `value` | `gsaiw)` | `(value)` |

---

## Flash.nvim — Jump Anywhere in 2-3 Keystrokes

LazyVim includes flash.nvim. It supercharges `f`/`t`/`/`:

| Key | What it does |
|-----|-------------|
| `s` | Flash jump — type 1-2 chars, then a label to land there |
| `S` | Flash treesitter — select a treesitter node |
| `r` (operator-pending) | Remote flash — e.g. `yr{label}` yanks from remote location |

> `s` replaces the old vim `s` (substitute char). Use `cl` instead if you need that behavior.

### With operators

| Command | What it does |
|---------|-------------|
| `ds{label}` | Delete from cursor to flash target |
| `ys{label}` | Yank from cursor to flash target |
| `vs{label}` | Visual select to flash target |

### Example

```
// cursor at top — want to jump to "handleSubmit" 20 lines below
function LoginForm() {
  ...
  const handleSubmit = () => {

s         → flash mode activates
ha        → type first 2 chars of "handleSubmit"
          → labels appear on all "ha" matches
k         → press the label next to handleSubmit (varies)
          → cursor lands on "handleSubmit" instantly
```

```
// cursor on line 5 — want to delete everything up to "return" on line 12
ds        → flash mode in delete-operator
re        → type "re" for "return"
j         → press label → deletes from cursor to "return"
```

---

## Golden Rules

- **`cgn` + `.`** for selective rename — learn this first
- **`f`/`t` + operators** for precise line edits — `dt)`, `cf,`, `ct:`
- **`d/pattern`** for deleting irregular chunks
- **Visual select → `;r`** to search project for any code fragment
- **Structure edits for `.` repeat** — one motion, one operator
- Use the correct insert command (`a`, `A`, `o`, `O`)
- Use `<C-o>` for one action only
- Use Normal mode for multi-step edits
- Let plugins handle repetitive JSX work (ts-autotag, treesitter)
