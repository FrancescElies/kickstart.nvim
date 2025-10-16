local tele_builtin = require 'telescope.builtin'

local function notes_live_grep(opts)
  tele_builtin.live_grep { cwd = '~/src/_notes' }
  vim.fn.feedkeys(opts.what)
end

vim.keymap.set('n', '<leader>nh', function()
  notes_live_grep { what = 'ONHOLD' }
end, { desc = '[n]otes view on[h]old' })

vim.keymap.set('n', '<leader>nt', function()
  notes_live_grep { what = 'TODO' }
end, { desc = '[n]otes view [t]odos' })

vim.keymap.set('n', '<leader>ng', function()
  notes_live_grep { what = '' }
end, { desc = '[n]otes [g]rep' })

vim.keymap.set('n', '<leader>nf', function()
  tele_builtin.find_files { cwd = '~/src/_notes/' }
end, { desc = '[n]ote [f]iles' })

return {
  -- {
  --   -- go install github.com/zyedidia/eget@latest
  --   -- eget zk-org/zk
  --   'zk-org/zk-nvim',
  --   config = function()
  --     require('zk').setup {
  --       -- See Setup section below
  --     }
  --   end,
  -- },
}
