-- Global keymaps. Buffer-local LSP/telescope keymaps live with those plugins.
-- See `:help vim.keymap.set`.

local map = vim.keymap.set

-- Clear search highlight by hitting <Esc> in normal mode.
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Send all diagnostics in the buffer to the location list.
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Easier terminal-mode exit than the default <C-\><C-n>.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Arrow keys nag you to use hjkl. Remove these if you ever need real arrows.
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window focus with Ctrl + hjkl (no Ctrl-w prefix needed).
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- File explorer (oil). <leader>e opens it at the current file's directory,
-- <leader>E opens it at the git repo root (falling back to cwd outside repos).
map('n', '<leader>e', ':Oil<CR>', { desc = 'Open file explorer at current' })
map('n', '<leader>E', function()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then git_root = vim.loop.cwd() end
  vim.cmd('Oil ' .. git_root)
end, { desc = 'Open file explorer at git root' })
