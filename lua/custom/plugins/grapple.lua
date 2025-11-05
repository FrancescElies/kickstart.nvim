return {
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git', -- also try out "git_branch"
    },
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    cmd = 'Grapple',
    keys = {
      { 'M', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
      { 'm.', '<cmd>Grapple tag<cr>', desc = 'Grapple add tag' },
      { 'H', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
      { 'L', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
    },
  },
  -- {
  --   'otavioschwanck/arrow.nvim',
  --   dependencies = {
  --     { 'nvim-tree/nvim-web-devicons' },
  --     -- or if using `mini.icons`
  --     -- { "echasnovski/mini.icons" },
  --   },
  --   opts = {
  --     show_icons = true,
  --     leader_key = 'M',
  --     buffer_leader_key = '\\', -- Per Buffer Mappings
  --   },
  --   keys = {
  --     {
  --       'H',
  --       function()
  --         require('arrow.persist').previous()
  --       end,
  --     },
  --     {
  --       'L',
  --       function()
  --         require('arrow.persist').next()
  --       end,
  --     },
  --   },
  -- },
}
