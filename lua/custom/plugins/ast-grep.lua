return {
  'ray-x/telescope-ast-grep.nvim',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope.nvim'},
  },
  keys = {
    { '<leader>sT', ':Telescope AST_grep<cr>', desc = 'search by as[t] grep' },
    { '<leader>sj', ':Telescope dumb_jump<cr>', desc = 'ast [j]ump definition' },
  },
}
