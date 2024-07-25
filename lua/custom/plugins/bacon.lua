return {
  'Canop/nvim-bacon',
  keys = {
    { '!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', desc = 'next [r]ust issue' },
    { '<leader>b', ':BaconList<CR>', desc = '[b]acon list' },
    { ',', ':BaconList<CR>', desc = '[b]acon list' },
  },
}
