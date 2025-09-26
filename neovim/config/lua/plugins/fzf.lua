return {
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
}
