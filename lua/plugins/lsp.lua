-- Language Server Protocol setup.
--
-- Mason installs servers/tools into ~/.local/share/nvim/mason/. Anything
-- listed in `servers` below gets installed and enabled automatically.
-- Anything in `tools` is installed but not enabled as an LSP — formatters,
-- linters, debug adapters live there.
--
-- Buffer-local LSP keymaps (rename, code action, etc.) are registered in
-- the LspAttach autocmd here. Telescope-backed jump pickers (grr/grd/…)
-- are wired up in plugins/telescope.lua.

---@module 'lazy'
---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Required so mason-tool-installer can resolve lspconfig names
      -- (e.g. `lua_ls`) to Mason package names (`lua-language-server`).
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Floating "LSP is doing work…" indicators in the corner.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Runs once per LSP-buffer pair. Sets up keymaps + niceties scoped to that buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          -- Note: declaration ≠ definition. In C this jumps to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Highlight all references of the symbol under the cursor when it
          -- rests there for a moment. Cleared on cursor move or LSP detach.
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints (parameter names, inferred types) for servers that support them.
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers Mason should install and enable.
      -- Add a new server by adding a `name = { ...config }` entry here.
      ---@type table<string, vim.lsp.Config>
      local servers = {
        lua_ls = {
          on_init = function(client)
            -- We format Lua via stylua (conform.nvim), not lua_ls.
            client.server_capabilities.documentFormattingProvider = false

            -- If the project has its own .luarc.json, defer to it.
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                -- Listing the full runtime is slow + noisy on the nvim config itself.
                -- See neovim/nvim-lspconfig#3189.
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          ---@type lspconfig.settings.lua_ls
          settings = {
            Lua = { format = { enable = false } },
          },
        },
      }

      -- Non-LSP tools to keep installed via Mason (formatters, linters, DAPs).
      local tools = { 'stylua' }

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, tools)
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
