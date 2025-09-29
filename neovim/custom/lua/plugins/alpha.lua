return {
  { -- Dashboard config
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'
      local ascii = require 'ascii'

      -- ASCII Art Header
      -- More art: https://github.com/MaximilianLloyd/ascii.nvim
      dashboard.section.header.val = ascii.get_random('text', 'neovim')

      -- Menu Buttons
      dashboard.section.buttons.val = {
        dashboard.button('s', '  Restore Session', "<cmd>lua require('persistence').load()<cr>"),
        dashboard.button('n', '  New File', '<cmd>enew<cr>'),
        dashboard.button('f', '  Find File', "<cmd>lua require('fzf-lua').files()<cr>"),
        dashboard.button('g', '  Find Word', "<cmd>lua require('fzf-lua').live_grep()<cr>"),
        dashboard.button('c', '  Edit Config', '<cmd>edit $MYVIMRC<cr>'),
        dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
      }

      -- Startup Logic:
      -- Conditionally start alpha. If a session was restored, alpha will be hidden.
      -- If there is no session to restore, alpha will be shown.
      local function on_session_load()
        local successful, session = pcall(require('persistence').load)
        if successful and session then
          -- If a session was restored, hide Alpha
          require('alpha').close()
        end
      end

      -- If persistence.nvim is set up, use its logic, otherwise just start alpha
      if pcall(require, 'persistence') then
        vim.api.nvim_create_autocmd('VimEnter', {
          nested = true,
          pattern = '*',
          callback = on_session_load,
        })
      else
        -- Fallback to just showing the dashboard if persistence isn't available
        alpha.setup(dashboard.opts)
      end

      -- If no session was restored, show the dashboard
      if not vim.g.persistence_loaded then
        alpha.setup(dashboard.opts)
      end
    end,
  },
}
