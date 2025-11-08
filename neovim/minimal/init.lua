-- A minimal neovim config that can be copied to limited resource environment
-- No plugins in this config

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Always show the tabline, so the buffer list is visible
vim.o.showtabline = 2

-- Enable mouse mode, can be useful for resizing splits
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Set tab width to 2 spaces
vim.o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
vim.o.expandtab = false -- Use spaces instead of tabs.
vim.o.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations.

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- [[ Buffer Navigation and Management ]]
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>%bd|e#<CR>', { desc = 'Close All Other Buffers' })
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'Next Buffer' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
  pattern = '*',
  callback = function(event)
    -- Check if the file mark is set
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_num = mark[1]
    local last_line = vim.api.nvim_buf_line_count(event.buf)

    -- If the mark is valid (line > 0 and not past the end of the file), jump to it
    if line_num > 0 and line_num <= last_line then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})