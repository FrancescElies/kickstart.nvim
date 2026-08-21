-- :Inspect to show the highlight groups under the cursor
-- :InspectTree to show the parsed syntax tree ("TSPlayground")
-- :EditQuery to open the Live Query Editor (Nvim 0.10+)

local fn = require 'custom.fn'

vim.pack.add { fn.gh 'nvim-treesitter/nvim-treesitter-context' }
local tscontext = require 'treesitter-context'

tscontext.setup {
  enable = true,
  multiwindow = true,
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
  separator = '-',
}

vim.keymap.set('n', '<leader>to', '<cmd>TSContext toggle<cr>', { desc = 'toggle TS-c[o]ntext' })
-- [p is one of the few free keys :/, is nicely placed close to [
vim.keymap.set('n', '[p', function() tscontext.go_to_context(vim.v.count1) end, { silent = true, desc = 'prev context' })
