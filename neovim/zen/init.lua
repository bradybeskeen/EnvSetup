-- A zen neovim config that can be copied to limited resource environment
-- No plugins in this config

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Options ]]

vim.o.number = true
vim.o.relativenumber = true
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

-- [[ Statusline ]]
_G.ZenStatusline = function()
  local mode_map = {
    n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
    ['\22'] = 'V-BLOCK', c = 'COMMAND', R = 'REPLACE', t = 'TERMINAL', s = 'SELECT',
  }
  local mode = mode_map[vim.fn.mode()] or vim.fn.mode()
  local file = vim.fn.expand '%:t'
  if file == '' then file = '[No Name]' end
  local modified = vim.bo.modified and ' [+]' or ''
  local readonly = vim.bo.readonly and ' [RO]' or ''
  local ft = vim.bo.filetype ~= '' and vim.bo.filetype or ''
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  local total = vim.fn.line '$'
  local pct = total > 0 and math.floor(line / total * 100) .. '%%' or '0%%'
  return string.format(' %s  %s%s%s %%=%s  %d:%d  %s ', mode, file, modified, readonly, ft, line, col, pct)
end
vim.o.statusline = '%!v:lua.ZenStatusline()'

-- [[ Tabline ]]
_G.ZenTabline = function()
  local s = ''
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
      if name == '' then name = '[No Name]' end
      local modified = vim.bo[buf].modified and ' [+]' or ''
      if buf == vim.api.nvim_get_current_buf() then
        s = s .. '%#TabLineSel# ' .. name .. modified .. ' %#TabLine#'
      else
        s = s .. '%#TabLine# ' .. name .. modified .. ' '
      end
    end
  end
  return s .. '%#TabLineFill#'
end
vim.o.tabline = '%!v:lua.ZenTabline()'
vim.o.showtabline = 2

-- [[ Netrw ]]
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.keymap.set('n', 'q', function()
      local ok = pcall(vim.cmd, 'Rex')
      if not ok then vim.cmd 'bprevious' end
    end, { buffer = true })
  end,
})

-- [[ Keymaps ]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>%bd|e#<CR>', { desc = 'Close All Other Buffers' })
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'Next Buffer' })

-- File explorer
vim.keymap.set('n', '<leader>e', '<cmd>Explore<CR>', { desc = 'File Explorer' })

-- Auto-pairs (brackets only)
local autopairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
for open, close in pairs(autopairs) do
  vim.keymap.set('i', open, open .. close .. '<Left>')
end
vim.keymap.set('i', '<BS>', function()
  local col = vim.fn.col '.'
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(col - 1, col - 1)
  local after = line:sub(col, col)
  local close_map = { ['('] = ')', ['['] = ']', ['{'] = '}' }
  if close_map[before] == after then
    return '<BS><Del>'
  end
  return '<BS>'
end, { expr = true })

-- [[ Autocommands ]]

-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('zen-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = vim.api.nvim_create_augroup('zen-last-loc', { clear = true }),
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
