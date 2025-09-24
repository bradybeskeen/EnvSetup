-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.guifont = 'Go Mono Nerd Font:h14'
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o` or `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Always show the tabline, so the buffer list is visible
vim.o.showtabline = 2

-- Enable mouse mode, can be useful for resizing splits
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

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
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
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

-- Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

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

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.
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
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
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
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Trouble' },
        { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
        { '<leader>c', group = 'code' },
        { '<leader>w', group = 'window' },
        { '<leader>g', group = 'git' },
        { '<leader>f', group = 'find' },
        { '<leader>b', group = 'buffers' },
        { '<leader>x', group = 'extras' },
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>tx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>tX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>tL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>tQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }

      require('mini.tabline').setup {
        show_buffers = true,
        show_tabs = false,
        show_args = false,
        -- Enable smart mouse support
        enable_mouse = true,
        -- Show buffer icons
        show_icons = vim.g.have_nerd_font,
      }
    end,
  },
  { -- Better command prompt
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    keys = {
      {
        '<leader>n',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Open Notification History',
      },
    },
  },
  { -- Fuzzy Finder
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- For file icons
      { 'folke/trouble.nvim', optional = true },
    },
    cmd = 'FzfLua',
    opts = function()
      local fzf = require 'fzf-lua'
      local actions = fzf.actions

      local trouble_actions
      if pcall(require, 'trouble.sources.fzf') then
        trouble_actions = require('trouble.sources.fzf').actions
      end

      return {
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          prompt_icon = '❯ ',
          preview = { scrollchars = { '┃', '' } },
        },
        fzf_opts = { ['--no-scrollbar'] = true },
        files = {
          cwd_prompt = false, -- Display path relative to CWD
          actions = {
            ['default'] = actions.file_edit,
            ['ctrl-t'] = trouble_actions and trouble_actions.open,
            ['ctrl-r'] = function(_, ctx)
              local opts = ctx.__call_opts
              opts.root = not opts.root
              fzf.files(opts)
            end,
            ['alt-i'] = actions.toggle_ignore,
            ['alt-h'] = actions.toggle_hidden,
          },
        },
        grep = {
          actions = {
            ['alt-i'] = actions.toggle_ignore,
            ['alt-h'] = actions.toggle_hidden,
          },
        },
      }
    end,
    keys = {
      -- find
      { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
      {
        '<leader>fc',
        function()
          require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Config File',
      },
      {
        '<leader>ff',
        function()
          require('fzf-lua').files()
        end,
        desc = 'Find Files (Root Dir)',
      },
      {
        '<leader>fF',
        function()
          require('fzf-lua').files { cwd_only = true }
        end,
        desc = 'Find Files (cwd)',
      },
      { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Find Files (git-files)' },
      { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
      {
        '<leader>fR',
        function()
          require('fzf-lua').oldfiles { cwd = vim.fn.getcwd() }
        end,
        desc = 'Recent (cwd)',
      },
      -- git
      { '<leader>gc', '<cmd>FzfLua git_commits<CR>', desc = 'Commits' },
      { '<leader>gs', '<cmd>FzfLua git_status<CR>', desc = 'Status' },
      -- search
      { '<leader>s"', '<cmd>FzfLua registers<cr>', desc = 'Registers' },
      { '<leader>sa', '<cmd>FzfLua autocmds<cr>', desc = 'Auto Commands' },
      { '<leader>sb', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Buffer' },
      { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
      { '<leader>sC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
      { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
      { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },
      { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
      { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'Search Highlight Groups' },
      { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumplist' },
      { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Key Maps' },
      { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'Location List' },
      { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'Man Pages' },
      { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Jump to Mark' },
      { '<leader>sR', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
      { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },
      {
        '<leader>sg',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = 'Grep (Root Dir)',
      },
      {
        '<leader>sG',
        function()
          require('fzf-lua').live_grep { cwd_only = true }
        end,
        desc = 'Grep (cwd)',
      },
      {
        '<leader>sw',
        function()
          require('fzf-lua').grep_cword()
        end,
        desc = 'Word (Root Dir)',
      },
      {
        '<leader>sW',
        function()
          require('fzf-lua').grep_cword { cwd_only = true }
        end,
        desc = 'Word (cwd)',
      },
      {
        '<leader>sw',
        function()
          require('fzf-lua').grep_visual()
        end,
        mode = 'v',
        desc = 'Selection (Root Dir)',
      },
      {
        '<leader>sW',
        function()
          require('fzf-lua').grep_visual { cwd_only = true }
        end,
        mode = 'v',
        desc = 'Selection (cwd)',
      },
      {
        '<leader>xc',
        function()
          require('fzf-lua').colorschemes()
        end,
        desc = 'Colorschemes',
      },
      {
        '<leader>ss',
        function()
          require('fzf-lua').lsp_document_symbols()
        end,
        desc = 'Goto Symbol',
      },
      {
        '<leader>sS',
        function()
          require('fzf-lua').lsp_live_workspace_symbols()
        end,
        desc = 'Goto Symbol (Workspace)',
      },
    },
  },
  -- LSP Plugins
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
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

          --Find references for the word under your cursor.
          map('grr', require('fzf-lua').lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          map('gri', require('fzf-lua').lsp_implementations, 'Goto Implementation')

          -- Jump to the definition of the word under your cursor.
          map('grd', require('fzf-lua').lsp_definitions, 'Goto Definition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('grD', vim.lsp.buf.declaration, 'Goto Declaration')

          -- Fuzzy find all the symbols in your current document.
          map('gO', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          map('gW', require('fzf-lua').lsp_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          map('grt', require('fzf-lua').lsp_typedefs, 'Goto Type Definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider then
            map('<leader>xh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
      --  Create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- See `:help lspconfig-all`
      local servers = {
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        clangd = {},
        gopls = {},
        zls = {},
        ts_ls = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'shfmt',
        'prettier',
        'clang-format',
        'gofumpt',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        vue = { 'prettier' },
        javascript = { 'prettier', 'clang-format', stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },
      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { --Using the tokyonight colorscheme
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Set up all the mini.nvim modules here in one place
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

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
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      -- See :TSInstallInfo for opts
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'go',
        'zig',
        'javascript',
        'typescript',
        'vue',
        'css',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
}
