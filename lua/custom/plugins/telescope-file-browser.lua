return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    { '<space>fB', ':Telescope file_browser<CR>' },
    { '<space>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>' },
  },
}
