-- You find yourself frequenting a small set of files and you are tired of using a fuzzy finder,
-- :bnext & :bprev are getting too repetitive, alternate file doesn't quite cut it, etc etc.
return {
  'ThePrimeagen/harpoon',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = '[H]arpoon [A]dd file' })
    vim.keymap.set('n', '<leader>ht', ui.toggle_quick_menu, { desc = '[H]arpoon [T]oggle quick menu' })
    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)
    vim.keymap.set('n', '<C-n>', ui.nav_next, { desc = 'Harpoon nav [N]ext' })
    vim.keymap.set('n', '<C-p>', ui.nav_prev, { desc = 'Harpoon nav [P]revious' })
    vim.keymap.set('n', '<leader>h1', function() ui.nav_file(1) end, { desc = '[H]arpoon goto file [1]' })
    vim.keymap.set('n', '<leader>h2', function() ui.nav_file(2) end, { desc = '[H]arpoon goto file [2]' })
    vim.keymap.set('n', '<leader>h3', function() ui.nav_file(3) end, { desc = '[H]arpoon goto file [3]' })
    vim.keymap.set('n', '<leader>h4', function() ui.nav_file(4) end, { desc = '[H]arpoon goto file [4]' })
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
