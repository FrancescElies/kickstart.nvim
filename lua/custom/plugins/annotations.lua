local opts = { noremap = true, silent = true }

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  keys = {
    { '<leader>nf', ":lua require('neogen').generate()<CR>", desc = 'Generate a[N]notation', opts },
    {
      '<leader>nc',
      ":lua require('neogen').generate({ type = 'class' })<CR>",
      desc = 'Generate a[N]notation for [C]lass',
      opts,
    },
  },
}
