-- Entry point. Loads non-plugin config first (options/keymaps/etc.) then
-- bootstraps lazy.nvim, which picks up every spec under lua/plugins/.

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.diagnostics'
require 'config.lazy'

-- vim: ts=2 sts=2 sw=2 et
