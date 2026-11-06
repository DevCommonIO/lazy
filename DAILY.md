# Daily Workflow: My Source of Truth

> The commands I use every day: editing, refactoring, searching and navigating
> TS/React/Expo and Java code, plus tmux panes for running apps, logs, docs and DBs.
> Every key here was checked against my actual config (2026-11-06).
> Open this file: `<leader>H`. Full reference: `SHORTCUTS.md` (`<leader>?`). Discover keys live: `<leader>sk`, or press `<leader>` and wait.
>
> Leader = `Space` · tmux prefix = `Ctrl+Space` · ⭐ = learn these first

---

## 0. Start the day

| Step | Keys |
|---|---|
| Open / switch project session ⭐ | `prefix f` → type project name → Enter (opens nvim in that repo) |
| Back to previous project | `prefix L` |
| Split a pane for the app / logs ⭐ | `Alt+v` side by side · `Alt+s` stacked (or `Cmd+D` / `Cmd+Shift+D`) |
| Move between nvim splits **and** tmux panes ⭐ | `Alt+h/j/k/l` (or `Cmd+h/j/k/l`) |
| Zoom a pane full screen / back | `prefix z` |

---

## 1. Navigate files

| Action | Keys |
|---|---|
| Find file in project ⭐ | `<leader><leader>` (or `;f`, which respects .gitignore) |
| Recent files | `<leader>fr` |
| Open buffers | `<leader>,` · previous / next buffer `H` / `L` · last buffer `<leader>bb` |
| File explorer (tree) | `<leader>ee` · reveal current file `<leader>ef` · open in Finder `<leader>eo` |
| Close buffer / other buffers | `<leader>bd` / `<leader>bo` |
| Bookmark this file (harpoon) | `<leader>ha` · menu `<leader>hh` |
| Jump to bookmark 1/2/3/4 ⭐ | `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+n` |
| Jump back / forward (any jump) ⭐ | `Ctrl+o` / `Ctrl+i` |
| Resume last picker | `;;` |
| New file | `<leader>fn` · or in the explorer press `a` |

**Inside the explorer:** `a` add (end with `/` for a folder) · `r` rename · `d` delete · `m` move · `c` copy · `y` yank path · `Enter` open · `q` close.

---

## 2. Navigate code (methods, classes, symbols)

| Action | Keys |
|---|---|
| Go to definition ⭐ | `gd` |
| Find references / usages ⭐ | `gr` |
| Go to implementation (interface → class) | `gI` |
| Go to type definition | `gy` |
| Go to declaration | `gD` |
| Hover docs / type ⭐ | `K` |
| Signature help | `gK` (also pops up automatically while typing arguments) |
| Symbols in this file (methods, classes) ⭐ | `<leader>ss` (or `;s`) |
| Symbols in whole workspace | `<leader>sS` |
| Outline panel (Trouble) | `<leader>cs` |
| Next / prev function | `]f` / `[f` (end: `]F` / `[F`) |
| Next / prev class | `]c` / `[c` |
| Next / prev parameter | `]a` / `[a` |
| Next / prev usage of word under cursor | `]]` / `[[` (or `Alt+n` / `Alt+p`) |
| Jump anywhere on screen | `s` + 2 chars + label (Flash) |
| Select a whole TS node (function, JSX…) | `S` (Flash Treesitter) |
| Grow / shrink selection by syntax node | `Alt+Space` (repeat) / `Backspace` |
| Java: go to super method | `<leader>cgs` |

---

## 3. Search

| Action | Keys |
|---|---|
| Grep text in project ⭐ | `<leader>/` (or `<leader>sg`) |
| Grep word under cursor / selection ⭐ | `;r` · or `<leader>sw` |
| Search in this file (fuzzy) | `<leader>sb` (or `;b`) |
| Search in this file (vim) | `/text` → `n` / `N` · word under cursor `*` |
| TODO / FIXME list | `<leader>st` |
| Diagnostics: file / workspace | `;x` / `;w` · Trouble `<leader>xx` |
| Next / prev error | `]d` / `[d` · line message `<leader>cd` |
| Search keymaps / commands / help | `<leader>sk` / `<leader>sC` / `<leader>sh` |

---

## 4. Rename & replace

| Action | Keys |
|---|---|
| Rename symbol everywhere (live preview) ⭐ | `<leader>cr` → type → Enter |
| Rename current file (TS updates imports) ⭐ | `<leader>cR` |
| Search & replace in project (grug-far) ⭐ | `<leader>sr` (visual: uses the selection) |
| Replace in file | `:%s/old/new/gc` (`c` = confirm each) |
| Replace word under cursor in file | `:%s/<C-r><C-w>/new/gc` |
| Change next match, repeat with dot | `*` → `cgn` → type → `Esc` → `.` `.` `.` |

**grug-far tips:** type search on line 1, replacement on line 2, file filter (`*.tsx`) on the files line, then `<localleader>r` to replace all (`\r`; check `?` in the panel).

---

## 5. Refactor & code actions

| Action | Keys |
|---|---|
| Code actions (quick fix, import, etc.) ⭐ | `<leader>ca` |
| Source actions | `<leader>cA` |
| Format file / selection | `<leader>cf` |
| Organize imports (TS & Java) ⭐ | `<leader>co` |
| TS: add missing imports | `<leader>ci` |
| TS: remove unused imports | `<leader>cu` |
| Extract function (visual) | `<leader>rf` |
| Extract variable (visual) | `<leader>rv` |
| Inline variable | `<leader>ri` |
| Refactor menu | `<leader>re` |
| Java: extract variable / constant / method | `<leader>cxv` / `<leader>cxc` / `<leader>cxm` (visual) |
| Split / join object, args, JSX props | `<leader>m` |
| Toggle comment | `gcc` line · `gc` + motion / visual |

---

## 6. Edit faster (text objects)

Combine an operator with an object: `d` delete · `c` change · `y` yank · `v` select.

| Object | Meaning | Example |
|---|---|---|
| `if` / `af` | inside / around **function** | `daf` delete whole method |
| `ic` / `ac` | inside / around **class** | `vac` select class |
| `ia` / `aa` | inside / around **argument** | `cia` change one parameter |
| `it` / `at` | inside / around **JSX/HTML tag** | `cit` change tag content |
| `io` / `ao` | inside / around **block** (if, loop, `{}`) | `dio` |
| `iq` / `aq` | inside / around **quotes** | `ciq` |
| `ib` / `ab` | inside / around **brackets** `() [] {}` | `yib` |

| Surround (mini.surround) | Keys |
|---|---|
| Add / delete / replace surrounding | `gsa` + motion + char · `gsd` + char · `gsr` + old + new |
| Example: wrap word in quotes | `gsaiw"` |

| Other | Keys |
|---|---|
| Move line / selection down / up | `Alt+Shift+j` / `Alt+Shift+k` (normal) · `Alt+j/k` (visual, insert) |
| Paste last **yank** (not last delete) | `<leader>p` after / `<leader>P` before · yank history picker `<leader>sy` |
| Yank to macOS clipboard | `<leader>y` (line: `<leader>Y`) |
| Delete char without yanking | `x` |
| Undo / redo | `u` / `Ctrl+r` |
| Exit insert mode | `jk` or `Esc` |

---

## 7. Completion & Copilot (insert mode)

| Action | Keys |
|---|---|
| Next / prev completion item | `Tab` / `Shift+Tab` |
| Accept completion | `Enter` |
| Open completion manually | `Alt+Space` |
| Snippet: next / prev placeholder | `Ctrl+j` / `Ctrl+k` |
| Copilot: accept ⭐ | `Ctrl+l` |
| Copilot: accept word / line | `Ctrl+→` / `Ctrl+↓` |
| Copilot: next / prev / dismiss | `Ctrl+]` / `Alt+p` / `Alt+e` |

---

## 8. Windows inside nvim

| Action | Keys |
|---|---|
| Split right / below ⭐ | `sv` / `ss` (or `<leader>\|` / `<leader>-`) |
| Close split / keep only this one | `sq` / `so` |
| Move between splits | `Alt+h/j/k/l` (or `sh/sj/sk/sl`) |
| Resize split | `Alt+←/→/↑/↓` |
| Close split / zoom split | `<leader>wd` / `<leader>wm` |
| Terminal inside nvim (quick command) | `Ctrl+/` toggle · `Esc Esc` → normal mode |

---

## 9. Git (in nvim)

| Action | Keys |
|---|---|
| LazyGit ⭐ | `<leader>gg` |
| Next / prev changed hunk | `]h` / `[h` |
| Preview / reset hunk | `<leader>gp` / `<leader>gr` |
| Stage hunk (git add) / stage file | `<leader>ga` / `<leader>gA` (visual `<leader>ga` = selection) |
| Git status / stash pickers | `<leader>gs` / `<leader>gS` |
| Blame line toggle | `<leader>gb` |
| Diff working tree / file history | `<leader>gv` / `<leader>gh` · close `<leader>gV` |
| Open line on GitHub / copy URL | `<leader>gB` / `<leader>gY` |

---

## 10. Tests & debug

| Action | Keys |
|---|---|
| Run nearest test ⭐ | `<leader>tr` |
| Run test file / Java class | `<leader>tt` |
| Run last test | `<leader>tl` |
| Test summary / output | `<leader>ts` / `<leader>to` |
| Java: pick test to run | `<leader>tT` |
| Toggle breakpoint / conditional | `<leader>db` / `<leader>dB` |
| Debug: continue / over / into / out / stop | `F5` / `F10` / `F11` / `F12` / `F8` |

---

## 11. tmux: the "other pane"

### Panes & windows

| Action | Keys |
|---|---|
| Split right / below | `Alt+v` / `Alt+s` |
| Move between panes | `Alt+h/j/k/l` |
| Resize pane | `Alt+←/→/↑/↓` |
| Zoom pane (toggle) ⭐ | `prefix z` |
| Kill pane (asks first) | `prefix x` |
| New window (for DB, docs…) | `Alt+c` · go to window `Alt+1..9` · rename `Alt+r` |
| List windows / sessions | `prefix w` / `prefix S` |

### Read logs & copy from a pane

| Action | Keys |
|---|---|
| Enter copy / scroll mode ⭐ | `Alt+y` (or scroll the mouse) |
| Search up / down in output | `?text` / `/text` → `n` / `N` |
| Select & copy to clipboard | `v` … move … `y` (line: `V`, block: `Ctrl+v`) |
| Leave copy mode | `q` or `Esc` |
| Mouse | drag = copy · double-click = word · triple-click = line |

### Typical layouts

```
┌──────────────────────┬────────────┐
│                      │ app / logs │   Alt+v from nvim → run app
│        nvim          │            │   Alt+s inside it → second log pane
│                      ├────────────┤   prefix z to zoom whichever you read
│                      │ tests/git  │
└──────────────────────┴────────────┘
Window 2 (Alt+c): database / docs · Alt+1 back to code
```

---

## 12. Run things (in the other pane)

### React / TypeScript (web)

```sh
npm run dev            # dev server
npm test -- --watch    # tests in watch mode
npx tsc --noEmit -w    # type-check the whole project continuously
```

### Expo (mobile)

```sh
npx expo start         # then in that pane: i = iOS sim · a = Android · r = reload · j = debugger · m = menu
npx expo start -c      # clear Metro cache (fixes weird bundling errors)
npx expo install <pkg> # install a package compatible with your Expo SDK
```

### Java / Spring Boot

```sh
./gradlew bootRun                       # run the app
./gradlew test                          # all tests
./gradlew test --tests '*MyServiceTest' # one class
./gradlew build -x test                 # build, skip tests
mvn spring-boot:run                     # Maven projects
```

Single tests with breakpoints: run them from nvim (`<leader>tr`), see `JAVA_RUN.md`.

### Databases

```sh
cinit / cdb      # (my zsh helpers) init / start local 3-node CockroachDB
sql              # (my zsh helper) cockroach SQL shell on the users DB
sqlite3 file.db  # SQLite
docker compose up -d db && docker compose logs -f db

ldb              # (my zsh alias) lazysql UI on the local CockroachDB users DB
lazysql          # connection manager: add Postgres / MySQL / SQLite connections
lazysql "postgres://user:pass@host:5432/db?sslmode=disable"   # any Postgres-compatible URL
```

**lazysql:** `j/k` move · `Enter` open table · `Tab` switch panel · `?` help (all keys) · `q` back / quit.

Cockroach/Postgres shell: `\l` databases · `\dt` tables · `\d table` describe · `\q` quit.
sqlite3: `.tables` · `.schema table` · `.quit`.

### Docs, tutorials, files

| Where | How |
|---|---|
| In nvim (best for `.md`) | open file → `<leader>um` toggle rendered view · `<leader>cp` preview in browser |
| In a pane: read rendered markdown ⭐ | `glow -p file.md` (pager: `/` search, `q` quit) |
| In a pane: browse all `.md` in a folder | `glow` (fuzzy list → `Enter` read · `Esc` back) |
| Plain file | `less file` |
| Jump to any folder | `z <part-of-name>` (zoxide) |

---

## 13. Known quirks in my config (so I don't get confused)

- **`s` alone is Flash** (jump). The `s` window keys (`ss sv sq so sh sj sk sl`) still work; Flash just waits a moment after `s` to see if a second key follows.
- **`;` is taken by Telescope** (`;f`, `;r`…). To repeat `f`/`t`, press `f`/`t` again (Flash).
- **`Ctrl+Space` is the tmux prefix**, so nvim never sees it. Expand selection is `Alt+Space`, open completion is `Alt+Space` in insert mode.
- Fixed 2026-11-06: `ss/sv/sq/so` now exist · `<leader>p` pastes last yank (history moved to `<leader>sy`) · stage hunk moved to `<leader>ga` so `<leader>gs` is always Git Status.

---

## 14. Practice plan

1. **Week 1:** sections 0–3 (⭐ only): `prefix f`, `Alt+hjkl`, `<leader><leader>`, `gd`/`gr`/`K`, `<leader>/`, `Ctrl+o`.
2. **Week 2:** sections 4–6: `<leader>cr`, `<leader>sr`, `<leader>ca`, `daf` / `cia` / `cit`.
3. **Week 3:** harpoon `Ctrl+h/j/k/l`, Flash `s`, `]f`/`[f`, tests `<leader>tr`.
4. Training games: `<leader>Tv` (VimBeGood) · `<leader>Tm` motions · `<leader>Tr` hardtime report.
