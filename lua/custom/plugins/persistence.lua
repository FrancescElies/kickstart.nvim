return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  keys = {
    {
      '<leader>po',
      function()
        require('persistence').load()
      end,
      desc = '[p]ersistence [o]open',
    },
    {
      '<leader>pw',
      function()
        require('persistence').save()
      end,
      desc = '[p]ersistence [w]rite',
    },
    {
      '<leader>ps',
      function()
        require('persistence').select()
      end,
      desc = '[p]ersistence [s]elect',
    },
    {
      '<leader>pl',
      function()
        require('persistence').load { last = true }
      end,
      desc = '[p]ersistence [l]oad [l]ast',
    },

    {
      '<leader>pt',
      function()
        require('persistence').stop()
      end,
      desc = '[p]ersistence s[t]op',
    },
  },
}
