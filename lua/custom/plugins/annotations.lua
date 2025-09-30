return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>cg', ':Neogen ', desc = '[c]ode [g]en docs' },
  },
}
