-- IDE config for Neovim

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.guifont = 'Go Mono Nerd Font:h14'
vim.g.have_nerd_font = true

-- [[ Clipboard ]]
-- Detects SSH and ensures the osc52 module exists before applying
if vim.env.SSH_TTY then
  local ok, osc52 = pcall(require, 'vim.ui.clipboard.osc52')
  if ok then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = { ['+'] = osc52.copy '+', ['*'] = osc52.copy '*' },
      paste = { ['+'] = osc52.paste '+', ['*'] = osc52.paste '*' },
    }
  end
end

-- Use system clipboard for all yanks
vim.o.clipboard = 'unnamedplus'

-- [[ Setting Options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.showtabline = 2
vim.o.mouse = 'a'
vim.o.showmode = false

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false
vim.o.softtabstop = 2

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.cmd.colorscheme 'lunaperche'

-- [[ Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>%bd|e#<CR>', { desc = 'Close other buffers' })
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'Next buffer' })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
  pattern = '*',
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_num = mark[1]
    local last_line = vim.api.nvim_buf_line_count(event.buf)
    if line_num > 0 and line_num <= last_line then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- [[ Plugin Manager Setup ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure Plugins ]]
require('lazy').setup {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      filter = function(mapping)
        return mapping.desc ~= nil and mapping.desc ~= ''
      end,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
        },
      },
      spec = {
        { '<leader>t', group = 'trouble' },
        { '<leader>c', group = 'code' },
        { '<leader>w', group = 'window' },
        { '<leader>b', group = 'buffer' },
        { '<leader>f', group = 'find' },
        { '<leader>x', group = 'extras' },
      },
    },
  },
  { import = 'plugins' },
}
