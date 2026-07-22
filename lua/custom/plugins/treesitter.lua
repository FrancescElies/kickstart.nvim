-- :Inspect to show the highlight groups under the cursor
-- :InspectTree to show the parsed syntax tree ("TSPlayground")
-- :EditQuery to open the Live Query Editor (Nvim 0.10+)

local fn = require('custom.fn')
vim.pack.add { fn.gh 'nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  enable = false,
  max_lines = '20%', -- How many lines the window should span. Values <= 0 mean no limit.
  separator = '-',
}

local function prev_context() require('treesitter-context').go_to_context(vim.v.count1) end
local function next_context() require('treesitter-context').go_to_context(-vim.v.count1) end

vim.keymap.set('n', '<leader>to', ':TSContext toggle<cr>', { desc = '[v]im treesitter-c[o]ntext toggle' })

vim.keymap.set('n', '[o', prev_context, { silent = true, desc = 'prev c[o]ntext' })
vim.keymap.set('n', ']o', next_context, { silent = true, desc = 'next c[o]ntext' })
