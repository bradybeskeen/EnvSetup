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
          fd_opts = [[--color=never --type f --hidden --no-ignore --exclude .git]],
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
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --no-ignore -g '!.git/' -e",
          rg_glob = true, -- allows inline glob: `pattern -- *.lua` or `pattern -- *.ts,*.js`
          silent = true, -- suppress false-positive "--line-number missing" warning from rg_glob
          actions = {
            ['alt-i'] = actions.toggle_ignore,
            ['alt-h'] = actions.toggle_hidden,
          },
        },
      }
    end,
    keys = {
      -- files
      { '<leader>bb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
      {
        '<leader>ff',
        function()
          require('fzf-lua').files()
        end,
        desc = 'Find Files (Root Dir)',
      },
      { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
      -- grep
      {
        '<leader>fg',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = 'Grep (Root Dir)',
      },
      {
        '<leader>fw',
        function()
          require('fzf-lua').grep_cword()
        end,
        desc = 'Word (Root Dir)',
      },
      {
        '<leader>fw',
        function()
          require('fzf-lua').grep_visual()
        end,
        mode = 'v',
        desc = 'Selection (Root Dir)',
      },
      -- symbols
      {
        '<leader>cs',
        function()
          require('fzf-lua').lsp_document_symbols()
        end,
        desc = 'Symbols',
      },
      {
        '<leader>cS',
        function()
          require('fzf-lua').lsp_live_workspace_symbols()
        end,
        desc = 'Symbols (Workspace)',
      },
      -- misc
      { '<leader>fB', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep Buffer' },
      { '<leader>fC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
      { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
      { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = 'Key Maps' },
      { '<leader>fz', '<cmd>FzfLua resume<cr>', desc = 'Resume Last Search' },
      -- extras
      {
        '<leader>xc',
        function()
          require('fzf-lua').colorschemes()
        end,
        desc = 'Colorschemes',
      },
    },
  },
}
