return {
  { 'lewis6991/gitsigns.nvim' },
  {
    'folke/persistence.nvim',
    event = 'VimEnter', -- Tries to load the session when you start nvim
    config = function()
      require('persistence').setup {}
    end,
  },
  {
    'MaximilianLloyd/ascii.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'm4xshen/autoclose.nvim', event = 'InsertEnter', config = true }, --Close brackets
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        commentStyle = { italic = false },
      }
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
