# Running & Debugging Java Spring Boot in LazyVim

## Prerequisites

Make sure these are installed and configured:

- **Java 21** (`java --version`)
- **JAVA_HOME** set in `~/.zshrc` (pointing to temurin-21)
- **LazyVim extras enabled** in `lua/config/lazy.lua`:
  - `lazyvim.plugins.extras.lang.java` — jdtls LSP, java-debug-adapter, java-test
  - `lazyvim.plugins.extras.dap.core` — DAP framework
  - `lazyvim.plugins.extras.test.core` — neotest framework
- **Mason packages** (installed automatically by the extras):
  - `jdtls` — Java language server
  - `java-debug-adapter` — DAP adapter for Java
  - `java-test` — JUnit test runner integration

Verify Mason packages with `:Mason` and check they show as installed.

## LSP — How It Works

When you open a `.java` file, `nvim-jdtls` starts automatically. It:
- Detects the Gradle project root (`build.gradle` / `settings.gradle`)
- Imports the project and resolves dependencies
- Provides completions, diagnostics, go-to-definition, etc.

First launch on a project takes 30-60 seconds while jdtls indexes. Watch `:LspInfo` or the status line for progress.

### Useful LSP Keymaps (built-in)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>co` | Organize imports (Java-specific) |
| `<leader>cxv` | Extract variable |
| `<leader>cxc` | Extract constant |
| `<leader>cxm` | Extract method (visual mode) |
| `<leader>cgs` | Go to super implementation |

## Running Unit Tests

### Option 1: Run individual tests with jdtls (recommended for debugging)

Open a test file and use these keymaps:

| Key | Action |
|---|---|
| `<leader>tr` | Run nearest test method (with DAP — supports breakpoints) |
| `<leader>tt` | Run all tests in current class |
| `<leader>tT` | Pick a test to run |

These run through JUnit directly via jdtls, not Gradle. They support full DAP debugging — set breakpoints before running and the debugger will stop at them.

### Option 2: Run via Gradle (full suite)

Open a terminal split (`:terminal` or `<C-/>`) and run:

```bash
# Unit tests only (no DB required)
./gradlew :service:test

# Functional tests (requires CockroachDB at localhost:26257)
./gradlew funcTests

# All tests
./gradlew test
```

## Debugging

### Debug a unit test

1. Open the test file
2. Set breakpoints with `<leader>db` (toggle) or `<leader>dB` (conditional)
3. Place cursor on the test method
4. Press `<leader>tr` — the test runs under the debugger and stops at breakpoints

### Debug the Spring Boot application

This uses a two-step attach workflow:

**Step 1 — Start the app with debug agent enabled**

In a terminal split (`:terminal` or a tmux pane), run:

```bash
./gradlew :service:bootRun --debug-jvm
```

This starts Spring Boot and pauses waiting for a debugger on port `5005`. You'll see:

```
Listening for transport dt_socket at address: 5005
```

> Note: You need the environment variables from `README.md` set in that shell
> for the app to connect to int2 services. The `MULTI_DOMAIN_ACCESS_SVC_ENV=local`
> profile is required.

**Step 2 — Attach the debugger from Neovim**

1. Open any `.java` file in the project
2. Set your breakpoints with `<leader>db`
3. Press `<F5>` (or `<leader>dc` — DAP continue)
4. Select **"Debug (Attach) - Spring Boot bootRun"** from the picker
5. The app resumes and the debugger is connected

### DAP keymaps while debugging

| Key | Action |
|---|---|
| `<F5>` | Start / Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<F8>` | Stop debugging |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |
| `<leader>dl` | Re-run last debug session |
| `<leader>dx` | Terminate debug session |

### DAP UI layout

When a debug session starts, the DAP UI opens automatically:
- **Left panel**: breakpoints, scopes (variables), watches, call stacks
- **Bottom panel**: REPL (evaluate expressions) and console output

The UI stays open after the session ends so you can inspect final state. Toggle it with `<leader>du`.

## Troubleshooting

### jdtls not starting

- Check `:LspInfo` — jdtls should appear as an active client
- Check `:LspLog` for errors
- Try `:JdtWipeDataAndRestart` to clear the workspace cache and reimport

### "No DAP config for filetype java"

- Ensure `java-debug-adapter` is installed: `:Mason` → search for `java-debug-adapter`
- Restart Neovim after installing — jdtls needs to load the debug bundles on startup

### Tests not discovered

- Wait for jdtls to finish indexing (status line shows progress)
- Ensure the file is a valid JUnit test (annotated with `@Test`)
- Try `:JdtWipeDataAndRestart` if the project structure changed

### Breakpoints not hit

- Confirm the debugger is attached (DAP UI should be open, status shows "running")
- Ensure you're hitting the code path — check console output
- For Spring Boot attach: make sure the app was started with `--debug-jvm`

### Slow Gradle import

First import of a Gradle project can take a few minutes. Subsequent opens use the cached workspace at `~/.cache/nvim/jdtls/`. If things get stale, wipe it:

```bash
rm -rf ~/.cache/nvim/jdtls/multi-domain-access-svc
```

Then reopen a Java file to trigger a fresh import.
