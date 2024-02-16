return {
  -- 'lstwn/broot.vim',
  -- 'skyuplam/broot.nvim',
  'FrancescElies/broot.nvim',
  -- dir = '~/src/oss/broot.nvim',
  -- keys = { { '<C-p>', ':Br<cr>', desc = 'broot' } },
  config = function()
    vim.keymap.set('n', '<C-p>', ':BrRoot<cr>', { desc = 'broot' })
    vim.keymap.set('n', '<leader>fb', ':Br<cr>', { desc = 'broot (current dir)' })
  end,
}
