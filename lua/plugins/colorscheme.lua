-- Colorschemes. tokyonight is loaded eagerly so it's the default;
-- moonfly is just along for the ride, swap with `:colorscheme moonfly`.

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- load before everything else so highlights apply immediately
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = { comments = { italic = false } },
      }
      -- Variants: tokyonight-night, -storm, -moon, -day.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  { 'bluz71/vim-moonfly-colors', name = 'moonfly', lazy = true },
}
