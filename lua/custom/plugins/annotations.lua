local opts = { noremap = true, silent = true }

require('which-key').register {
  ['<leader>a'] = { name = '[a]nnotate', _ = 'which_key_ignore' },
}

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>af', ":lua require('neogen').generate({ type = 'func' })<CR>", desc = '[a]nnotate function', opts },
    {
      '<leader>ac',
      ":lua require('neogen').generate({ type = 'class' })<CR>",
      desc = '[a]nnotate [c]lass',
      opts,
    },
  },
}
