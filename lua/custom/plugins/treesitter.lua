return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = false,
        max_lines = '30%', -- How many lines the window should span. Values <= 0 mean no limit.
        multiwindow = true,
      }
    end,
  },
}
