-- Diagnostic display config (LSP errors/warnings shown inline and in floats).
-- See `:help vim.diagnostic.Opts`.

vim.diagnostic.config {
  update_in_insert = false, -- don't recompute while you're typing
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true, -- inline message at end of line
  virtual_lines = false, -- set true if you want messages on their own lines
  jump = { float = true }, -- auto-show float when jumping with `[d` / `]d`
}
