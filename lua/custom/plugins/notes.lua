local tele_builtin = require 'telescope.builtin'

local function get_todos(dir)
  tele_builtin.live_grep { cwd = dir }
  vim.fn.feedkeys 'TODO'
end

vim.keymap.set('n', '<leader>nt', function()
  get_todos '~/src/_notes '
end, { desc = '[s]earch [n]otes [t]odos' })

vim.keymap.set('n', '<leader>ng', function()
  tele_builtin.live_grep { cwd = '~/src/_notes/' }
end, { desc = '[s]earch [n]otes by [g]rep' })

vim.keymap.set('n', '<leader>nf', function()
  tele_builtin.find_files { cwd = '~/src/_notes/' }
end, { desc = '[s]earch [n]otes [f]iles' })

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
