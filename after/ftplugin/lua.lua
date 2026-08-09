vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.keymap.set('n', '<localleader><localleader>', '<cmd>w|so %<cr>', { buffer = 0, desc = 'source current buffer' })
vim.keymap.set('v', '<localleader><localleader>', "<cmd>'<,'>lua<CR>", { buffer = 0, desc = 'source selection' })
vim.keymap.set('n', '<localleader>.', '<cmd>.lua<cr>', { buffer = 0, desc = 'source current [l]ine' })

