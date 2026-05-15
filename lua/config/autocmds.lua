-- Global autocommands. See `:help lua-guide-autocommands`.

-- Briefly highlight yanked text so you can see what got copied.
-- Try it: `yap` in normal mode.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
