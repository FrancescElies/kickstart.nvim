vim.keymap.set('n', '<leader>vq', function()
  require('quicker').toggle()
end, {
  desc = '[v]im Toggle [q]uickfix',
})
vim.keymap.set('n', '<leader>vl', function()
  require('quicker').toggle { loclist = true }
end, {
  desc = '[v]im Toggle [l]oclist',
})
return {
  -- {
  --   'kevinhwang91/nvim-bqf',
  --   config = function()
  --     require('bqf').setup()
  --   end,
  -- },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
    keys = {
      {
        '>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  },
}
