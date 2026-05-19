-- Formatter runner. <leader>f formats the current buffer on demand;
-- filetypes listed in `format_on_save` also auto-format on :w.

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      -- Opt-in per-filetype auto-formatting on save.
      format_on_save = function(bufnr)
        local enabled_filetypes = { go = true, lua = true }
        if enabled_filetypes[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
        return nil
      end,
      -- If no formatter is configured for a filetype, fall back to LSP formatting.
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Add more like: python = { 'black' }, javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
