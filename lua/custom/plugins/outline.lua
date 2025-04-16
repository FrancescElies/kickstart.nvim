return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
    -- Your setup opts here
  },
}

-- return {
--   'stevearc/aerial.nvim',
--   opts = {},
--   -- Optional dependencies
--   keys = {
--     { '<leader>o', '<cmd>AerialToggle!<CR>', desc = 'Toggle outline' },
--   },
--   dependencies = {
--     'nvim-treesitter/nvim-treesitter',
--     'nvim-tree/nvim-web-devicons',
--   },
-- }
