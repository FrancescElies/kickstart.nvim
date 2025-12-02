return {
  'ray-x/telescope-ast-grep.nvim',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope.nvim'},
  },
  keys = {
    { '<leader>tg', ':Telescope AST_grep<cr>', desc = 'as[t] grep' },
    { '<leader>td', ':Telescope dumb_jump<cr>', desc = 'as[t] goto definition' },
  },
}
