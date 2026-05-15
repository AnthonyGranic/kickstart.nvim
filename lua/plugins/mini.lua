-- A library of small focused modules from echasnovski. We use:
--   mini.ai       — better around/inside text objects (`va)`, `yi)`, `ci'`, …)
--   mini.surround — add/delete/replace surrounding brackets/quotes/tags
--   mini.statusline — minimal statusline
-- Browse the rest at https://github.com/echasnovski/mini.nvim.

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-mini/mini.nvim',
    config = function()
      -- around_next / inside_next are remapped from the default `an`/`in`
      -- to avoid clashing with treesitter's incremental selection on Neovim >= 0.12.
      -- See `:help treesitter-incremental-selection`.
      require('mini.ai').setup {
        mappings = { around_next = 'aa', inside_next = 'ii' },
        n_lines = 500, -- look this many lines around the cursor for a match
      }

      -- Examples:
      --   saiw)  surround-add-inner-word with )
      --   sd'    surround-delete '
      --   sr)'   surround-replace ) with '
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      -- Tighter cursor location display: LINE:COL instead of the default.
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
