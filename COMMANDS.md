# Commands & Keymaps

Quick reference for everything wired up in this config.
**Leader is `<Space>`** (and `<localleader>` is also Space).

A few conventions used below:
- `<C-…>` means hold Ctrl, `<S-…>` means Shift.
- "n", "v", "i", "t", "o", "x" prefixes refer to **normal**, **visual**, **insert**, **terminal**, **operator-pending**, and **visual+select** modes.
- "LSP" rows only fire on buffers where a language server has attached.

> Use `:WhichKey` to inspect any prefix interactively, or `:Telescope keymaps` (`<leader>sk`) to fuzzy-search them.

---

## Personal keymaps

### Quality of life
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<Esc>` | Clear search highlight |
| t    | `<Esc><Esc>` | Exit terminal mode (easier than `<C-\><C-n>`) |
| n    | `<leader>q` | Send buffer diagnostics to the location list |
| n    | `<left>`/`<right>`/`<up>`/`<down>` | Reminder echo: "Use h/j/k/l" |

### Window navigation
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<C-h>` | Focus left window |
| n    | `<C-j>` | Focus lower window |
| n    | `<C-k>` | Focus upper window |
| n    | `<C-l>` | Focus right window |

### File explorer (oil.nvim)
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<leader>e` | Open oil at the current file's directory |
| n    | `<leader>E` | Open oil at the git repo root (cwd outside repos) |
| n    | `-` | Open oil at parent directory (oil default) |

### Daily notes
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<leader>d` | Open today's daily note (`:DailyNote`) |
| n    | `<leader>j` | Open quick-jot floating window (`:Jot`) |
| n    | `<leader>sN` | Live-grep the notes repo |

Inside the jot window:
- Type your note (starts in insert mode)
- `:w` or `<C-s>` → append to a `## Jot` section in today's note (timestamped `### HH:MM`)
- `q` in normal mode → discard

Note path: `~/faire/notes/daily_notes/<YYYY-MM>/<YYYY-MM-DD>.md`.

Inside oil: edit the buffer like text, then `:w` commits moves/renames/deletes. `g?` for full oil help.

---

## Search & navigation (Telescope, `<leader>s…`)

| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<leader><leader>` | List open buffers |
| n    | `<leader>sf` | Find files |
| n    | `<leader>sp` | Find files **tracked by git** (project-aware) |
| n    | `<leader>sg` | Live grep across the project |
| n    | `<leader>s/` | Live grep across **open buffers** only |
| n,v  | `<leader>sw` | Grep for the word/selection under the cursor |
| n    | `<leader>/` | Fuzzy-find in the **current buffer** |
| n    | `<leader>s.` | Recent files |
| n    | `<leader>sd` | Diagnostics |
| n    | `<leader>sh` | Help tags |
| n    | `<leader>sk` | Keymaps |
| n    | `<leader>sc` | Vim commands |
| n    | `<leader>ss` | Pick a Telescope picker |
| n    | `<leader>sr` | Resume last Telescope session |
| n    | `<leader>sn` | Find files in `~/.config/nvim` |

---

## LSP (buffer-local; require an attached server)

| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `grn` | Rename symbol |
| n,x  | `gra` | Code actions |
| n    | `grd` | Goto definition (Telescope) |
| n    | `grr` | Goto references (Telescope) |
| n    | `gri` | Goto implementation (Telescope) |
| n    | `grt` | Goto type definition (Telescope) |
| n    | `grD` | Goto declaration |
| n    | `gO` | Document symbols (Telescope) |
| n    | `gW` | Workspace symbols (Telescope) |
| n    | `<leader>th` | Toggle inlay hints |
| n    | `<C-o>` | Jump back (after `grd` etc.) |
| n    | `<C-i>` / `<Tab>` | Jump forward |

### Diagnostics navigation
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `]d` / `[d` | Next / previous diagnostic |
| n    | `[D` / `]D` | First / last diagnostic |

---

## Format (conform.nvim)

| Mode | Key | Action |
| :--- | :-- | :----- |
| n,v  | `<leader>f` | Format buffer (async) |

Auto-formats on save for: `go`.
Lua files are formatted via `stylua`.

---

## Completion (blink.cmp, insert mode)

| Mode | Key | Action |
| :--- | :-- | :----- |
| i    | `<C-y>` | Accept (auto-import if LSP supports it) |
| i    | `<C-Space>` | Open menu / toggle docs |
| i    | `<C-n>` / `<C-p>` | Next / previous item |
| i    | `<Up>` / `<Down>` | Next / previous item |
| i    | `<C-e>` | Hide menu |
| i    | `<C-k>` | Toggle signature help |
| i    | `<Tab>` / `<S-Tab>` | Jump between snippet placeholders |

---

## Git (gitsigns)

### Navigation
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `]c` | Next change/hunk (vim's `]c` in diff mode) |
| n    | `[c` | Previous change/hunk |

### Hunk actions (`<leader>h…`)
| Mode | Key | Action |
| :--- | :-- | :----- |
| n,v  | `<leader>hs` | Stage hunk (or selection) |
| n,v  | `<leader>hr` | Reset hunk (or selection) |
| n    | `<leader>hS` | Stage entire buffer |
| n    | `<leader>hR` | Reset entire buffer |
| n    | `<leader>hp` | Preview hunk (floating window) |
| n    | `<leader>hi` | Preview hunk **inline** |
| n    | `<leader>hb` | Blame current line (full) |
| n    | `<leader>hd` | Diff against index |
| n    | `<leader>hD` | Diff against last commit |
| n    | `<leader>hq` | Hunks → quickfix (current file) |
| n    | `<leader>hQ` | Hunks → quickfix (whole repo) |

### Toggles (`<leader>t…`)
| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<leader>tb` | Toggle inline blame on current line |
| n    | `<leader>tw` | Toggle intra-line word diff |

### Text object
| Mode | Key | Action |
| :--- | :-- | :----- |
| o,x  | `ih` | "inside hunk" — `dih`, `yih`, `vih`, etc. |

---

## Trouble (`<leader>x…` for lists, `<leader>c…` for code)

| Mode | Key | Action |
| :--- | :-- | :----- |
| n    | `<leader>xx` | All diagnostics |
| n    | `<leader>xX` | Diagnostics for current buffer |
| n    | `<leader>xL` | Location list |
| n    | `<leader>xQ` | Quickfix list |
| n    | `<leader>cs` | Document symbols (sidebar) |
| n    | `<leader>cl` | LSP refs/defs/impls (right panel) |

`:Trouble <mode>` for direct invocation.

---

## Text objects & operators

### mini.ai (extended text objects)
Targets work with any operator (`d`, `c`, `y`, `v`, …):

| Key  | Selects |
| :--- | :------ |
| `a)` / `i)` | around / inside `()` |
| `a]` / `i]` | around / inside `[]` |
| `a}` / `i}` | around / inside `{}` |
| `a"` / `i"` | around / inside `""` |
| `a'` / `i'` | around / inside `''` |
| `aa` / `ii` | around / inside **next** occurrence (remapped from `an`/`in` to avoid treesitter incremental selection clash) |
| `af` / `if` | around / inside a function call (filetype-aware) |
| `ac` / `ic` | around / inside a class |

`a?` / `i?` prompt for a custom delimiter.

### mini.surround (add/delete/replace)

| Key   | Action |
| :---- | :----- |
| `sa{motion}{char}` | Surround add — e.g. `saiw)` wraps inner-word in `()` |
| `sd{char}` | Surround delete |
| `sr{old}{new}` | Surround replace |
| `sf` / `sF` | Find next/previous surrounding character |
| `sh` | Highlight surrounding |

---

## Kotlin (active in `.kt` / `.kts` buffers)

Uses `kotlin-lsp` (JetBrains) via Mason. Standard LSP keymaps apply (`grd`, `grr`, `grn`, etc.). Plugin commands:

| Command | Action |
| :------ | :----- |
| `:KotlinHealth` | Plugin health check (Mason package, JRE, root markers) |
| `:KotlinCleanWorkspace` | Stop LSP and wipe `~/.cache/kotlin-lsp-workspaces/<project>` + JetBrains analyzer cache |
| `:KotlinDebug` | Start debug session (requires nvim-dap, not installed here) |
| `:KotlinSymbols` | Open symbols in Trouble |
| `:KotlinWorkspaceSymbols` | Workspace symbols in Trouble |

> First open of a Gradle project triggers a full dependency import — can take many minutes on monorepos. Tail `~/.cache/kotlin-lsp-workspaces/<project>/system/log/intellij-server.log` to watch progress.

---

## Useful built-in / plugin commands

| Command | What it does |
| :------ | :----------- |
| `:Lazy`            | Plugin manager UI |
| `:Lazy update`     | Update all plugins |
| `:Mason`           | LSP/formatter/linter installer UI |
| `:LspInfo` / `:checkhealth lsp` | LSP status |
| `:checkhealth`     | Run all health checks (`:checkhealth kotlin`, `lazy`, etc.) |
| `:Telescope`       | List all Telescope pickers |
| `:Oil`             | Open the file explorer at cwd |
| `:Trouble`         | Open the Trouble list (`:Trouble diagnostics`, etc.) |
| `:ConformInfo`     | Show conform.nvim status / configured formatters |
| `:TodoTelescope`   | Telescope picker over TODO/NOTE/FIX comments |
| `:WhichKey`        | Show pending keymap chains |

---

## Vim defaults worth remembering

A few that come up often and aren't redefined here:

| Key  | Action |
| :--- | :----- |
| `gd` | Goto local definition (treesitter-aware, fallback to LSP via `grd`) |
| `K`  | Hover docs (LSP default in Neovim 0.10+) |
| `gx` | Open URL under cursor |
| `gq{motion}` | Format text via formatprg |
| `gv` | Re-select last visual selection |
| `g;` / `g,` | Older / newer position in change list |
| `<C-o>` / `<C-i>` | Older / newer position in jump list |
| `*` / `#` | Search word under cursor forward/back |
