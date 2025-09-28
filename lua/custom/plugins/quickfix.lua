-- stylua: ignore start
-- vim.keymap.set('n', '<leader>vq', function() require('quicker').toggle() end, { desc = '[v]im Toggle [q]uickfix', })
-- vim.keymap.set('n', '<leader>vl', function() require('quicker').toggle { loclist = true } end, { desc = '[v]im Toggle [l]oclist' })
-- stylua: ignore end

return {
  -- {
  --   'stevearc/quicker.nvim',
  --   event = 'FileType qf',
  --   ---@module "quicker"
  --   ---@type quicker.SetupOptions
  --   opts = {},
  --   keys = {
  --     {
  --       '<M->>',
  --       function()
  --         require('quicker').expand { before = 2, after = 2, add_to_existing = true }
  --       end,
  --       desc = 'Expand quickfix context or >',
  --     },
  --     {
  --       '<M-<>',
  --       function()
  --         require('quicker').collapse()
  --       end,
  --       desc = 'Collapse quickfix context or <',
  --     },
  --   },
  -- },
  {
    'kevinhwang91/nvim-bqf',
    enabled = false,
    config = function()
      require('bqf').setup()
    end,
  },
  {
    'stevearc/qf_helper.nvim',
    opts = {},
  },
}
