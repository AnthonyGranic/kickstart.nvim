-- You can add your own plugins here or in other files in this directory!

---@module 'lazy'
---@type LazySpec
return {

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
  },
}
