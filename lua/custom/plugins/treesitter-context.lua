return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = '10%', -- How many lines the window should span. Values <= 0 mean no limit.
      multiwindow = true,
    },
    keys = {
      { '<leader>vc', ':TSContext toggle<cr>', desc = '[v]im treesitter-[c]ontext toggle' },
    },
  },
}
