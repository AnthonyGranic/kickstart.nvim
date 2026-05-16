-- Edit your filesystem like a buffer. Open with `-` on any buffer or
-- via the <leader>e / <leader>E keymaps in config/keymaps.lua.
-- :w to commit moves/renames/deletes.

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      -- Show dotfiles/folders by default. Toggle at runtime with `g.` inside oil.
      view_options = { show_hidden = true },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- Loaded eagerly so opening nvim on a directory hands off to oil.
    lazy = false,
  },
}
