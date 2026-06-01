-- Core editor options. See `:help vim.o` and `:help option-list`.

-- Leader keys must be set before any plugin loads so plugin keymaps
-- resolve <leader> to the same character (space).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Lets icon-using plugins (which-key, mini.statusline, etc.) draw glyphs.
vim.g.have_nerd_font = true

-- Force Eastern time for os.date / strftime — this machine's system clock is UTC.
-- Affects daily-notes timestamps + anything else that formats local time.
vim.env.TZ = 'America/New_York'

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

-- Clipboard: OSC 52 lets the terminal forward yanks to the host clipboard
-- over SSH, so no xclip/pbcopy is needed on this remote box. We deliberately
-- do NOT set clipboard=unnamedplus — plain `y` stays in the unnamed register;
-- only explicit `"+y` / `"+p` (or `"*`) crosses to the system clipboard.
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste '+',
    ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}
