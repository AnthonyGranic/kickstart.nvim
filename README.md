# nvim

Personal Neovim configuration. Forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), then modularized and tailored.

## Quick reference

- [**COMMANDS.md**](./COMMANDS.md) — every keymap and useful command in one place.
- `:checkhealth` — run after install to verify everything is wired up.
- `:Lazy` — plugin manager UI.
- `:Mason` — install/update language servers and tools.

## Structure

```
.
├── init.lua                 # Entry point — just requires the modules below
├── lua/
│   ├── config/              # Non-plugin neovim configuration
│   │   ├── options.lua      # vim.o / vim.opt settings
│   │   ├── keymaps.lua      # Global keymaps
│   │   ├── autocmds.lua     # Autocommands
│   │   ├── diagnostics.lua  # vim.diagnostic.config
│   │   └── lazy.lua         # lazy.nvim bootstrap + setup
│   └── plugins/             # One file per plugin / tight group
│       ├── colorscheme.lua  # tokyonight + moonfly
│       ├── completion.lua   # blink.cmp + LuaSnip
│       ├── formatting.lua   # conform.nvim
│       ├── git.lua          # gitsigns + hunk keymaps
│       ├── kotlin.lua       # kotlin.nvim (kotlin-lsp via JetBrains)
│       ├── lsp.lua          # nvim-lspconfig + mason + fidget
│       ├── mini.lua         # mini.ai / mini.surround / mini.statusline
│       ├── oil.lua          # File explorer (edit fs as a buffer)
│       ├── telescope.lua    # Fuzzy finder + extensions
│       ├── treesitter.lua   # Syntax / indent / textobjects
│       ├── trouble.lua      # Diagnostics / refs list UI
│       ├── ui.lua           # which-key, todo-comments, autopairs, guess-indent
│       └── custom/          # Local "plugins" written in this repo (no GitHub source)
│           └── daily_notes.lua  # <leader>d / <leader>j / <leader>sN + Jot floating window
├── COMMANDS.md              # Keymap & command reference
├── lazy-lock.json           # Pinned plugin versions (commit this!)
└── README.md
```

`lua/plugins/` is auto-imported by `lazy.nvim` — drop a new file in there to add a plugin. The `custom/` subdir is imported separately (see `lua/config/lazy.lua`) and is the home for in-repo "plugins" you write yourself.

## Installation

### Dependencies

- Neovim ≥ 0.11 (this config uses `vim.lsp.config` / `vim.lsp.enable`)
- `git`, `make`, `unzip`, a C compiler
- [`ripgrep`](https://github.com/BurntSushi/ripgrep), [`fd`](https://github.com/sharkdp/fd)
- Tree-sitter CLI (`tree-sitter`)
- A Nerd Font in your terminal (toggle in `lua/config/options.lua` via `vim.g.have_nerd_font`)
- Language-specific:
  - **Kotlin**: Mason installs `kotlin-lsp`. The current build (v262.4739.0+) ships its own bundled JetBrains Runtime, so no Java install is required on the host.

### Install

```sh
git clone <this-repo> "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

`lazy.nvim` clones itself on first run, then installs every plugin. `mason-tool-installer` then fetches the LSP servers and tools listed in `lua/plugins/lsp.lua`.

## Adding a plugin

Drop a new file in `lua/plugins/`:

```lua
-- lua/plugins/my-plugin.lua
---@module 'lazy'
---@type LazySpec
return {
  { 'author/repo', opts = {} },
}
```

That's it — `lazy.nvim` picks it up on the next start.

### Adding a local "plugin" (no GitHub source)

For config-as-plugin modules (custom commands, keymaps, autocmds grouped as a feature), drop a file in `lua/plugins/custom/`:

```lua
-- lua/plugins/custom/my-feature.lua
---@module 'lazy'
---@type LazySpec
return {
  {
    'my-feature',                       -- arbitrary name
    dir = vim.fn.stdpath 'config',      -- points at an existing dir so lazy doesn't try to clone
    lazy = false,                       -- or use `event`, `keys`, etc. to lazy-load
    config = function()
      -- register commands, keymaps, autocmds…
    end,
  },
}
```

See `lua/plugins/custom/daily_notes.lua` for a working example.

## Adding an LSP server

Edit `lua/plugins/lsp.lua` and add an entry to the `servers` table:

```lua
local servers = {
  lua_ls = { ... },
  pyright = {},          -- empty table = defaults
  ts_ls = {},
  -- ...
}
```

Mason installs and enables it next time you launch nvim. Non-LSP tools (formatters, linters, DAPs) go in the `tools` list a few lines below.

## Notes & gotchas

- **kotlin-lsp is slow on first open of a large Gradle project.** It runs a full dependency import that can take many minutes on a monorepo. `:checkhealth kotlin` shows whether it's attached; tail `~/.cache/kotlin-lsp-workspaces/<project>/system/log/intellij-server.log` to watch progress.
- **Lua files are formatted via `stylua`** (run by conform.nvim), not by `lua_ls`. The LSP's `documentFormattingProvider` is explicitly disabled in `on_init` to avoid double formatting.
- **Auto-format on save is opt-in per filetype.** Currently only `go`. Edit `format_on_save` in `lua/plugins/formatting.lua` to add more.
- `lazy-lock.json` is committed so all machines get the same plugin versions; run `:Lazy update` to bump.
