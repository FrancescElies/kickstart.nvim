vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions' -- terminal?

return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
    -- stylua: ignore
    keys = {
      { '<leader>po', function() require('persistence').load() end, desc = '[p]ersistence [o]open' },
      { '<leader>ps', function() require('persistence').select() end, desc = '[p]ersistence [s]elect' },
      { '<leader>pl', function() require('persistence').load { last = true } end, desc = '[p]ersistence [l]oad [l]ast' },
      { '<leader>pp', function() require('persistence').stop() end, desc = '[p]ersistence stop' },
    },
  },
}
