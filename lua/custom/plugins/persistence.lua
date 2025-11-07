vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

return {
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/src', '~/Downloads', '/' },
      -- Telescope only: If load_on_setup is false, make sure you use `:AutoSession search` to open the picker as it will initialize everything first
      load_on_setup = true,
      -- log_level = 'debug',
    },
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>pr', '<cmd>AutoSession search<CR>', desc = '[p]ersist [r]ecent session' },
      { '<leader>ps', '<cmd>AutoSession save<CR>', desc = '[p]ersist [s]ave session' },
      { '<leader>pa', '<cmd>AutoSession toggle<CR>', desc = '[p]ersist toggle [a]utosave' },
    },
  },
  -- {
  --   'folke/persistence.nvim',
  --   event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  --   opts = {
  --     -- add any custom options here
  --   },
  --   keys = {
  --     {
  --       '<leader>po',
  --       function()
  --         require('persistence').load()
  --       end,
  --       desc = '[p]ersistence [o]open',
  --     },
  --     {
  --       '<leader>pw',
  --       function()
  --         require('persistence').save()
  --       end,
  --       desc = '[p]ersistence [w]rite',
  --     },
  --     {
  --       '<leader>ps',
  --       function()
  --         require('persistence').select()
  --       end,
  --       desc = '[p]ersistence [s]elect',
  --     },
  --     {
  --       '<leader>pl',
  --       function()
  --         require('persistence').load { last = true }
  --       end,
  --       desc = '[p]ersistence [l]oad [l]ast',
  --     },
  --
  --     {
  --       '<leader>pt',
  --       function()
  --         require('persistence').stop()
  --       end,
  --       desc = '[p]ersistence s[t]op',
  --     },
  --   },
  -- },
}
