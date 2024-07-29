local opts = { noremap = true, silent = true }

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>xa', ':Neogen func', desc = '[a]nnotate class, func, file, type', opts },
  },
}
