return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
  },
}
