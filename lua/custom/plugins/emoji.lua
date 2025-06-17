return {
  'nvim-telescope/telescope-symbols.nvim',
  keys = {
    {
      '<leader>e',
      function()
        require('telescope.builtin').symbols { sources = { 'emoji', 'kaomoji', 'gitmoji' } }
      end,
      desc = '[i]nsert [e]moji',
    },
  },
}
