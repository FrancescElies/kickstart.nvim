vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- lua
vim.keymap.set('n', '<localleader>b', '<cmd>w|so %<cr>', { desc = '[l]ua source current buffer' })
vim.keymap.set('v', '<localleader><localleader>', "<cmd>'<,'>lua<CR>", { desc = '[l]ua source selection' })
vim.keymap.set('n', '<localleader><localleader>', '<cmd>.lua<cr>', { desc = '[l]ua source current [l]ine' })
-- :
vim.keymap.set('n', '<localleader>le', '"ey$:!<c-r>e<cr>', { desc = '[l]ua source vim command (:) to [e]nd of line' })

