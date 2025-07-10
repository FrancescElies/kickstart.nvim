return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
      }
    end,
  },
}
