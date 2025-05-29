local opts = { noremap = true, silent = true }

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>cc', ':Neogen func', desc = '[c]ode [c]omment class, func, file, type', opts },
  },
}
