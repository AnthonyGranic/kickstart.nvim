-- Kotlin LSP via JetBrains' kotlin-lsp (Mason package `kotlin-lsp`).
-- The plugin auto-discovers the binary and builds the right command —
-- the `cmd` field is intentionally not set here, it would be ignored.

---@module 'lazy'
---@type LazySpec
return {
  {
    'AlexandrosAlexiou/kotlin.nvim',
    ft = { 'kotlin' },
    -- mason.nvim is the only hard dependency; oil/trouble are optional
    -- integrations the plugin probes for at runtime.
    dependencies = { 'mason.nvim', 'oil.nvim', 'trouble.nvim' },
    config = function()
      require('kotlin').setup {
        -- gradlew matches first in this monorepo; .git is the cwd fallback.
        root_markers = { 'gradlew', '.git', 'mvnw', 'settings.gradle' },
        -- Bigger heap for the JetBrains analyzer on large projects.
        jvm_args = { '-Xmx16g' },
        inlay_hints = { enabled = true },
        folding = { enabled = true },
      }
    end,
  },
}
