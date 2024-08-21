local opts = { noremap = true, silent = true }

return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', ':Oil<cr>', desc = 'open parent dir', opts },
    { '<leader>fd', ':Oil<cr>', desc = 'open parent [d]dir', opts },
  },
}
