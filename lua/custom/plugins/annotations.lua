local opts = { noremap = true, silent = true }

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>a', ':Neogen func', desc = '[a]nnotate class, func, file, type', opts },
  },
}
