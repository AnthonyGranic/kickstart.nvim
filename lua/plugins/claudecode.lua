-- Claude Code IDE integration. Spawns the `claude` CLI in a split terminal
-- and exposes it over the same WebSocket/MCP protocol the official VS Code
-- and JetBrains extensions use, so Claude can see the current buffer,
-- selections, diagnostics, and apply diffs back into nvim.
--
-- Keymaps (all under <leader>a):
--   ac  toggle Claude     af  focus       ar  resume      aC  continue
--   am  pick model        ab  add buffer  as  send selection / add file (oil)
--   aa  accept diff       ad  deny diff
--
-- Requires the `claude` CLI on $PATH (it is, at ~/.local/bin/claude).

---@module 'lazy'
---@type LazySpec
return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    -- Open diffs in their own tab so the original window is preserved; <leader>aa/ad
    -- closes the diff tab and returns to it. (Plugin has no floating-diff layout.)
    opts = {
      diff_opts = {
        open_in_new_tab = true,
        hide_terminal_in_new_tab = true,
      },
    },
    keys = {
      { '<leader>a', nil, desc = '[A]I/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Claude: toggle' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude: [f]ocus' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Claude: [r]esume' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Claude: [C]ontinue' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Claude: select [m]odel' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude: add current [b]uffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Claude: [s]end selection' },
      -- In oil (and friends), <leader>as adds the file under the cursor instead.
      { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Claude: add file', ft = { 'oil', 'NvimTree', 'neo-tree', 'minifiles', 'netrw' } },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Claude: [a]ccept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Claude: [d]eny diff' },
    },
  },
}
