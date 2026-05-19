-- Fuzzy finder for files, buffers, grep, LSP symbols, and more.
-- Keymaps under <leader>s and a couple of LSP-attached ones (grr, gri, etc.).

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Native C fuzzy matcher — much faster than the Lua fallback.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      -- Replaces vim.ui.select (e.g. code action chooser) with a Telescope popup.
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- Extensions are pcall-loaded so a missing one doesn't break startup.
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      local map = vim.keymap.set

      -- Search pickers (<leader>s…)
      map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- Capital variants include hidden + gitignored files for those rare "where the hell
      -- did I put that .env example" moments.
      map('n', '<leader>sF', function() builtin.find_files { hidden = true, no_ignore = true } end, { desc = '[S]earch [F]iles (incl. hidden + ignored)' })
      map('n', '<leader>sG', function() builtin.live_grep { additional_args = { '--hidden', '--no-ignore' } } end, { desc = '[S]earch by [G]rep (incl. hidden + ignored)' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      map('n', '<leader>s.', function() builtin.oldfiles { only_cwd = true } end, { desc = '[S]earch Recent Files ("." for repeat)' })
      map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      -- Project-aware file picker — only shows files tracked by git.
      map('n', '<leader>sp', builtin.git_files, { desc = '[S]earch in Git [P]roject' })

      -- LSP-driven pickers, bound when an LSP attaches to the buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          map('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          map('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          map('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
          map('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
          map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          map('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      -- In-buffer fuzzy search with a compact dropdown look.
      map(
        'n',
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = '[/] Fuzzily search in current buffer' }
      )

      -- Grep limited to currently open buffers.
      map(
        'n',
        '<leader>s/',
        function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Quick access to your own neovim config.
      map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
