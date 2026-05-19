-- Daily-note shortcuts. Not a real plugin — wrapped as a `virtual = true`
-- lazy.nvim spec so it lives alongside the other plugin entries and gets
-- picked up by `{ import = 'plugins.custom' }`. Don't use `dir = stdpath('config')`
-- here — lazy merges specs that share `dir`, so two fake-plugins both pointing
-- there silently collapse into one.
--
--   <leader>d  / :DailyNote   — open today's note
--   <leader>j  / :Jot         — floating window that appends to a `## Jot` section
--   :Jot <text>               — append <text> directly, no window
--   <leader>sN                — live-grep the notes repo
-- Today's note path: <repo>/daily_notes/<YYYY-MM>/<YYYY-MM-DD>.md

---@module 'lazy'
---@type LazySpec
return {
  {
    'daily-notes',
    virtual = true,
    lazy = false,
    config = function()
      -- Canonical notes repo location. Update if you move the repo.
      local NOTES_REPO_ROOT = vim.fn.expand '~/faire/notes'
      local DAILY_DIR = NOTES_REPO_ROOT .. '/daily_notes'

      -- Compute the path to today's note, ensuring the month folder + file exist
      -- (with a date header). Returns the path.
      local function ensure_today_note()
        local d = os.date '*t'
        local path = string.format('%s/%04d-%02d/%04d-%02d-%02d.md', DAILY_DIR, d.year, d.month, d.year, d.month, d.day)
        vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
        if vim.fn.filereadable(path) == 0 then
          local header = string.format('# %04d-%02d-%02d', d.year, d.month, d.day)
          vim.fn.writefile({ header, '' }, path)
        end
        return path
      end

      -- Open (creating if needed) today's note.
      local function open_today() vim.cmd('edit ' .. vim.fn.fnameescape(ensure_today_note())) end

      -- Append `content` (string, may be multi-line) to a `## Jot` section in
      -- today's note. Creates the section if it doesn't exist. New entries are
      -- inserted at the end of the existing section (before any later `## …`
      -- heading) and get timestamped as `### HH:MM`.
      local function append_jot(content)
        local path = ensure_today_note()
        local lines = vim.fn.readfile(path)
        local entry = { '', '### ' .. os.date '%H:%M' }
        for _, line in ipairs(vim.split(content, '\n', { plain = true })) do
          table.insert(entry, line)
        end

        -- Locate `## Jot` and the start of the next `## ` heading (if any).
        local jot_idx, next_heading_idx
        for i, line in ipairs(lines) do
          if not jot_idx and line == '## Jot' then
            jot_idx = i
          elseif jot_idx and not next_heading_idx and line:match '^##%s' then
            next_heading_idx = i
          end
        end

        if jot_idx then
          -- Insert right before the next `## ` heading, or at EOF. Skip trailing
          -- blank lines so we tuck cleanly against the section's last content.
          local insert_at = next_heading_idx and (next_heading_idx - 1) or #lines
          while insert_at > jot_idx and lines[insert_at] == '' do
            insert_at = insert_at - 1
          end
          for i, l in ipairs(entry) do
            table.insert(lines, insert_at + i, l)
          end
        else
          if #lines > 0 and lines[#lines] ~= '' then table.insert(lines, '') end
          table.insert(lines, '## Jot')
          for _, l in ipairs(entry) do
            table.insert(lines, l)
          end
        end

        vim.fn.writefile(lines, path)
      end

      -- Open a centered floating window with a markdown scratch buffer. `:w` (or
      -- <C-s> in any mode) appends what you typed to today's note's Jot section
      -- and closes the window. `q` in normal mode discards.
      local function open_jot_window()
        local buf = vim.api.nvim_create_buf(false, true)
        -- `acwrite` (not `nofile`) so `:w` triggers our BufWriteCmd instead of erroring.
        vim.bo[buf].buftype = 'acwrite'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].filetype = 'markdown'
        vim.api.nvim_buf_set_name(buf, '[Jot]')

        local width = math.min(80, math.floor(vim.o.columns * 0.7))
        local height = math.min(15, math.floor(vim.o.lines * 0.4))
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          border = 'rounded',
          title = ' Jot — :w / <C-s> to save, q to discard ',
          title_pos = 'center',
        })

        vim.cmd 'startinsert'

        local function commit()
          local body = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
          -- Strip surrounding whitespace so empty buffers don't produce empty jots.
          body = body:gsub('^%s+', ''):gsub('%s+$', '')
          if body == '' then
            vim.notify('Empty jot — discarded', vim.log.levels.INFO)
          else
            append_jot(body)
            vim.notify('Jotted', vim.log.levels.INFO)
          end
          if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        end

        -- `:w` lands here because the scratch buffer has no file backing.
        vim.api.nvim_create_autocmd('BufWriteCmd', { buffer = buf, callback = commit })
        vim.keymap.set({ 'n', 'i' }, '<C-s>', function()
          vim.cmd 'stopinsert'
          commit()
        end, { buffer = buf })
        vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
      end

      vim.api.nvim_create_user_command('DailyNote', open_today, { desc = "Open today's daily note" })
      -- `:Jot` with no args opens the floating window; `:Jot some text` appends
      -- `some text` straight to the Jot section without opening a buffer.
      vim.api.nvim_create_user_command('Jot', function(opts)
        if opts.args == '' then
          open_jot_window()
        else
          append_jot(opts.args)
          vim.notify('Jotted', vim.log.levels.INFO)
        end
      end, { nargs = '*', desc = "Quick-jot to today's note (no args: floating window; with args: append directly)" })

      vim.keymap.set('n', '<leader>d', open_today, { desc = "Open today's [D]aily note" })
      vim.keymap.set('n', '<leader>j', open_jot_window, { desc = '[J]ot to today’s note' })

      -- Live-grep the notes repo from anywhere. Lazy-requires telescope so this
      -- module can load before the plugin spec runs.
      vim.keymap.set('n', '<leader>sN', function() require('telescope.builtin').live_grep { cwd = NOTES_REPO_ROOT, prompt_title = 'Live Grep · notes' } end, { desc = '[S]earch [N]otes repo' })
    end,
  },
}
