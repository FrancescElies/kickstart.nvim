return {
  'Wansmer/treesj',
  keys = {
    { 'J', '<cmd>TSJToggle<cr>', desc = 'Join Toggle' },
    -- {
    --   '<leader>m',
    --   function()
    --     require('treesj').toggle()
    --   end,
    --   desc = 'split/join (treesj)',
    -- },
    -- {
    --   '<leader>M',
    --   function()
    --     require('treesj').toggle { split = { recursive = true } }
    --   end,
    --   desc = 'split/join (recursive treesj)',
    -- },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  opts = {
    use_default_keymaps = false,
  },
}
