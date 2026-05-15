-- Treesitter: syntax-aware highlighting, indentation, and text objects.
-- Uses the `main` branch (the v2 rewrite) so configuration looks different
-- from older guides — there's no big `ensure_installed` block in setup, parsers
-- are installed via require('nvim-treesitter').install({...}).

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- Parsers to keep installed for common filetypes.
      -- Other parsers auto-install on demand below (FileType autocmd).
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then return end
        vim.treesitter.start(buf, language)

        -- Treesitter indentation if the parser provides an indents query;
        -- otherwise vim's built-in indentexpr handles it.
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      local available_parsers = require('nvim-treesitter').get_available()

      -- For every file opened, attach treesitter if its parser is installed;
      -- auto-install if known to nvim-treesitter; otherwise try anyway in case
      -- a custom parser is on the runtimepath.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
