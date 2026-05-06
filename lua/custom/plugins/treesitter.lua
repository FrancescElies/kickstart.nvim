-- :Inspect to show the highlight groups under the cursor
-- :InspectTree to show the parsed syntax tree ("TSPlayground")
-- :EditQuery to open the Live Query Editor (Nvim 0.10+)
return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = false,
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
