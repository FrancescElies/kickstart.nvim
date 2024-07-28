local opts = { noremap = true, silent = true }

require('which-key').add {
  { '<leader>a', group = '[a]annotate' },
}

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>Af', ":lua require('neogen').generate({ type = 'func' })<CR>", desc = '[a]nnotate function', opts },
    {
      '<leader>Ac',
      ":lua require('neogen').generate({ type = 'class' })<CR>",
      desc = '[a]nnotate [c]lass',
      opts,
    },
  },
}
