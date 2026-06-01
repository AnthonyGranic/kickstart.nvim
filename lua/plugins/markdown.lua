-- Pretty-print markdown buffers in-place: headings get backgrounds, lists get
-- bullets, code fences get a tinted background, tables get drawn with box-
-- drawing characters. Toggle with `:RenderMarkdown toggle`.

---@module 'lazy'
---@type LazySpec
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- mini.nvim provides the icons; treesitter parses headings/code fences/etc.
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ft = { 'markdown' },
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', desc = 'Toggle [M]arkdown rendering' },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function(_, opts)
      require('render-markdown').setup(opts)

      -- Only customization on top of defaults: bump the code block background
      -- from ColorColumn (≈ tokyonight bg_highlight #292e42, almost identical
      -- to Normal bg) to a noticeably lighter shade so code blocks read as
      -- inset wells instead of vanishing into the editor background.
      local set_hl = vim.api.nvim_set_hl
      set_hl(0, 'RenderMarkdownCode', { bg = '#2a2f44' })
      set_hl(0, 'RenderMarkdownCodeInline', { bg = '#2a2f44', fg = '#7dcfff' })
    end,
  },
}
