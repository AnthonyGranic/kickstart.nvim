-- Small editor/UI plugins that don't deserve their own file.

---@module 'lazy'
---@type LazySpec
return {
  -- Auto-detect indent settings (tabs vs spaces, width) from the file you opened.
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Insert closing brackets/quotes as you type.
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- Show TODO / NOTE / FIX / HACK / WARN / PERF comments with color + telescope picker.
  -- `:TodoTelescope` to list them. <leader>st is bound below.
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  -- Floating popup showing the pending keymap continuation (e.g. after `<leader>`).
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      -- Group labels for leader-prefixed keys (cosmetic; doesn't define the keys).
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>x', group = 'Trouble' },
        { '<leader>c', group = '[C]ode' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
}
