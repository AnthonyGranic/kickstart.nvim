-- Floating zsh terminal. Not a real plugin — wrapped as a local lazy.nvim
-- spec (`dir = stdpath('config')`) so it lives alongside the other plugin
-- entries and gets picked up by `{ import = 'plugins' }`.
--
--   <leader>z  / :ZshTerm — toggle a floating interactive login zsh
--
-- Runs `zsh -il` so .zprofile and .zshrc are sourced (aliases, prompt, etc.
-- all work). The buffer + process persist across toggles so you can pop in,
-- run something, pop out, come back to the same scrollback. Close the shell
-- with `exit` and the buffer is wiped; next toggle starts fresh.

---@module 'lazy'
---@type LazySpec
return {
  {
    'zsh-term',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    config = function()
      local state = { buf = nil, win = nil }

      local function open_window()
        local width = math.floor(vim.o.columns * 0.85)
        local height = math.floor(vim.o.lines * 0.85)
        state.win = vim.api.nvim_open_win(state.buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          border = 'rounded',
          title = ' zsh ',
          title_pos = 'center',
        })
      end

      local function toggle()
        -- Visible → hide (keep buffer + job alive).
        if state.win and vim.api.nvim_win_is_valid(state.win) then
          vim.api.nvim_win_close(state.win, false)
          state.win = nil
          return
        end

        -- Hidden buffer exists → reopen it.
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
          open_window()
          vim.cmd 'startinsert'
          return
        end

        -- Fresh shell. Create the buffer first, attach the window, then
        -- termopen — termopen uses the current window's size to set TERM
        -- dimensions, so the float must already be the current window.
        state.buf = vim.api.nvim_create_buf(false, true)
        open_window()
        vim.fn.termopen({ 'zsh', '-il' }, {
          on_exit = function()
            if state.win and vim.api.nvim_win_is_valid(state.win) then vim.api.nvim_win_close(state.win, true) end
            if state.buf and vim.api.nvim_buf_is_valid(state.buf) then vim.api.nvim_buf_delete(state.buf, { force = true }) end
            state.win, state.buf = nil, nil
          end,
        })

        vim.cmd 'startinsert'
      end

      vim.api.nvim_create_user_command('ZshTerm', toggle, { desc = 'Toggle floating zsh terminal' })
    end,
  },
}
