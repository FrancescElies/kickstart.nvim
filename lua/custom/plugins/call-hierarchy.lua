local fn = require 'custom.fn'

vim.pack.add { fn.gh 'jmacadie/telescope-hierarchy.nvim' }
vim.keymap.set('n', 'grI', ':Telescope hierarchy incoming_calls<cr>', { desc = 'LSP: [I]ncoming Calls (recursive)' })
vim.keymap.set('n', 'grO', '<cmd>Telescope hierarchy outgoing_calls<cr>', { desc = 'LSP: [O]utgoing Calls (recursive)' })

-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the configs for us.
require('telescope').setup {
  -- don't use `defaults = { }` here, do this in the main telescope spec
  extensions = {
    hierarchy = {
      -- telescope-hierarchy.nvim config, see below
    },
    -- no other extensions here, they can have their own spec too
  },
}
require('telescope').load_extension 'hierarchy'
