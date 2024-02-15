return {
  -- 'lstwn/broot.vim',
  -- 'skyuplam/broot.nvim',
  'FrancescElies/broot.nvim',
  config = function()
    vim.keymap.set('n', '<C-p>', require('broot').broot, { desc = 'broot' })
  end,
}
