local tele_builtin = require 'telescope.builtin'

local function get_todos(dir, states)
  tele_builtin.live_grep { cwd = dir }
  vim.fn.feedkeys('^ *([*]+|[-]+) +[(]' .. states .. '[)]')
end

vim.keymap.set('n', '<leader>snt', function()
  get_todos('~/src/_notes ', '[^x_]')
end, { desc = '[s]earch [n]otes [t]odos' })

vim.keymap.set('n', '<leader>sng', function()
  tele_builtin.live_grep { cwd = '~/src/_notes/' }
end, { desc = '[s]earch [n]otes by [g]rep' })

vim.keymap.set('n', '<leader>snf', function()
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
