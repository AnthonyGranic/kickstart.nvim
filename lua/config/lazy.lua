-- Bootstrap lazy.nvim (clone it on first run) and load every spec under lua/plugins/.

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Auto-import every plugin spec in lua/plugins/. Add a new file there to add a plugin.
  { import = 'plugins' },
  -- Local "plugins" written in this repo (no GitHub source).
  { import = 'plugins.custom' },
}, { ---@diagnostic disable-line: missing-fields
  ui = {
    -- Nerd Font icons by default; the fallback table is used if you flip
    -- vim.g.have_nerd_font to false.
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
