return {
  'ray-x/telescope-ast-grep.nvim',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope.nvim'},
  },
  keys = {
    { '<leader>sG', ':Telescope AST_grep<cr>', desc = 'ast grep' },
    { '<leader>sj', ':Telescope dumb_jump<cr>', desc = 'ast [j]ump definition' },
  },
}
