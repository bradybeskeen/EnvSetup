-- A zen neovim config for limited resource environments
-- No plugins, optimized for headless servers

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Clipboard ]]
-- Use system clipboard for all yanks
vim.o.clipboard = 'unnamedplus'

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
    n = 'NORMAL',
    i = 'INSERT',
    v = 'VISUAL',
    V = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    c = 'COMMAND',
    R = 'REPLACE',
    t = 'TERMINAL',
    s = 'SELECT',
  }
  local mode = mode_map[vim.fn.mode()] or vim.fn.mode()
  local file = vim.fn.expand '%:t'
  file = (file == '') and '[No Name]' or file
  local modified = vim.bo.modified and ' [+]' or ''
  local readonly = vim.bo.readonly and ' [RO]' or ''
  local ft = vim.bo.filetype ~= '' and vim.bo.filetype or ''
  local line, col = vim.fn.line '.', vim.fn.col '.'
  local total = vim.fn.line '$'
  local pct = total > 0 and math.floor(line / total * 100) .. '%%' or '0%%'
  return string.format(' %s  %s%s%s %%=%s  %d:%d  %s ', mode, file, modified, readonly, ft, line, col, pct)
end
vim.o.statusline = '%!v:lua.ZenStatusline()'

-- [[ Tabline ]]
vim.api.nvim_set_hl(0, 'ZenTabLineCurrent', { bg = '#007A87', fg = '#ffffff', bold = true })

_G.ZenTabline = function()
  local s = ''
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
      name = (name == '') and '[No Name]' or name
      local modified = vim.bo[buf].modified and ' [+]' or ''
      if buf == vim.api.nvim_get_current_buf() then
        s = s .. '%#ZenTabLineCurrent# ' .. name .. modified .. ' '
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
      pcall(vim.cmd, 'Rex')
    end, { buffer = true })
  end,
})

-- [[ Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Window/Buffer Nav
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move Left' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move Down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move Up' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move Right' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>')
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>')
vim.keymap.set('n', 'L', '<cmd>bnext<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Explore<CR>')

-- Auto-pairs (Basic)
local autopairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
for open, close in pairs(autopairs) do
  vim.keymap.set('i', open, open .. close .. '<Left>')
end

vim.keymap.set('i', '<BS>', function()
  local col = vim.fn.col '.'
  local line = vim.api.nvim_get_current_line()
  local char_before = line:sub(col - 1, col - 1)
  local char_after = line:sub(col, col)
  if autopairs[char_before] == char_after then
    return '<BS><Del>'
  end
  return '<BS>'
end, { expr = true, replace_keycodes = true })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
