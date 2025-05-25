return {
  'cljoly/telescope-repo.nvim',
  keys = {
    { '<leader>po', '<cmd>Telescope repo<cr>', desc = '[p]roject [o]pen' },
    { '<M-p>', '<cmd>Telescope repo<cr>', desc = '[p]roject [o]pen' },
  },
  config = function()
    -- extension config in init.lua
    require('telescope').load_extension 'repo'
  end,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
}
