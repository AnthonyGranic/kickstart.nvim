-- Core editor options. See `:help vim.o` and `:help option-list`.

-- Leader keys must be set before any plugin loads so plugin keymaps
-- resolve <leader> to the same character (space).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Lets icon-using plugins (which-key, mini.statusline, etc.) draw glyphs.
vim.g.have_nerd_font = true

-- Line numbers: absolute current + relative for fast j/k motions.
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'
vim.o.showmode = false -- mode is shown in the statusline already
vim.o.breakindent = true
vim.o.undofile = true -- persistent undo across sessions

-- Case-insensitive unless you type a capital or \C.
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes' -- always show the gutter so text doesn't jump
vim.o.updatetime = 250 -- faster CursorHold / swapfile writes
-- How long vim waits for the next key in a multi-key sequence (e.g. `saiw)`).
-- 300ms is the kickstart default but cuts off slower typing — `s` would fire
-- its <Nop> before you reach the `a`. which-key has its own delay=0 so this
-- doesn't slow down the popup.
vim.o.timeoutlen = 1000

-- Splits open where you'd expect them.
vim.o.splitright = true
vim.o.splitbelow = true

-- Render hidden whitespace so trailing spaces / hard tabs are visible.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- live preview of :s substitutions
vim.o.cursorline = true
vim.o.scrolloff = 10 -- keep 10 lines visible above/below cursor
vim.o.confirm = true -- prompt to save instead of erroring on :q with unsaved changes

-- Clipboard: share with the OS clipboard. Scheduled after UiEnter
-- because looking up the system clipboard provider slows startup.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
