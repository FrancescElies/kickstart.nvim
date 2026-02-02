return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = '20%', -- How many lines the window should span. Values <= 0 mean no limit.
      separator = '-',
    },
    keys = {
      { '<leader>vc', ':TSContext toggle<cr>', desc = '[v]im treesitter-[c]ontext toggle' },
      {
        '[c',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        silent = true,
        desc = 'Go to context',
      },
      {
        ']c',
        function()
          require('treesitter-context').go_to_context(-vim.v.count1)
        end,
        silent = true,
        desc = 'Go to context',
      },
    },
  },
}
