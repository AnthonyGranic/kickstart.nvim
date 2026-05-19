-- Autocompletion via blink.cmp + LuaSnip for snippet expansion.
--
-- Default keybindings (preset = 'default'):
--   <C-y>     accept completion (auto-imports if LSP supports it)
--   <C-Space> open menu / toggle docs
--   <C-n>/<C-p> or <Up>/<Down> select next/previous
--   <C-e>     hide menu
--   <C-k>     toggle signature help
--   <Tab>/<S-Tab> jump between snippet placeholders

---@module 'lazy'
---@type LazySpec
return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        -- jsregexp gives LuaSnip regex transform support in snippets.
        -- Skipped on Windows where `make` typically isn't around.
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      snippets = { preset = 'luasnip' },
      -- Prefer the Rust fuzzy matcher (much faster); fall back to the Lua
      -- implementation with a one-time warning if the prebuilt binary isn't available.
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    },
  },
}
