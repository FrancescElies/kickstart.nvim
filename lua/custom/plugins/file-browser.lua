return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    { '-', ':Telescope file_browser<CR>' },
    { '_', ':Telescope file_browser path=%:p:h select_buffer=true<CR>' },
  },
}
