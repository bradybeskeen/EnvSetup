return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Set up all the mini.nvim modules here in one place
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }

      -- Configure and set up the statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      -- Customize the location section to be 'LINE:COLUMN'
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Configure and set up the tabline to show buffers
      require('mini.tabline').setup {
        show_buffers = true,
        show_tabs = false,
        show_args = false,
        enable_mouse = true,
        show_icons = vim.g.have_nerd_font,
      }

      -- Make active buffer clearly stand out in tabline (Sharks teal)
      vim.api.nvim_set_hl(0, 'MiniTablineCurrent', { bg = '#007A87', fg = '#ffffff', bold = true })
      vim.api.nvim_set_hl(0, 'MiniTablineModifiedCurrent', { bg = '#007A87', fg = '#ffffff', bold = true, italic = true })
    end,
  },
}
