return {
  -- 'lstwn/broot.vim',
  -- 'skyuplam/broot.nvim',
  'FrancescElies/broot.nvim',
  -- keys = { { '<C-p>', ':Br<cr>', desc = 'broot' } },
  config = function()
    vim.keymap.set('n', '<C-p>', require('broot').broot, { desc = 'broot' })
  end,
}
