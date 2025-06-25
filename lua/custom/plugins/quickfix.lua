-- stylua: ignore start
vim.keymap.set('n', '<leader>vq', function() require('quicker').toggle() end, { desc = '[v]im Toggle [q]uickfix', })
vim.keymap.set('n', '<leader>vl', function() require('quicker').toggle { loclist = true } end, { desc = '[v]im Toggle [l]oclist' })
-- stylua: ignore end

return {
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
          local q = require 'quicker'
          if q.is_open() then
            q.expand { before = 2, after = 2, add_to_existing = true }
          else
            vim.cmd 'normal! <M->>'
          end
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<M-<>',
        function()
          local q = require 'quicker'
          if q.is_open() then
            q.collapse()
          else
            vim.cmd 'normal! <M-<>'
          end
        end,
        desc = 'Collapse quickfix context',
      },
    },
  },
}
