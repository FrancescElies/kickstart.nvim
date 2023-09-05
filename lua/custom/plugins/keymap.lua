local line_with = { number = true, relativenumber = true }

local function toggle_number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    line_with = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  else
    vim.opt_local.number = line_with.number
    vim.opt_local.relativenumber = line_with.relativenumber
  end
end

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

-- Move to next and previous buffer with ease
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- quickfix
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>', { desc = '[Q]uickfix previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = '[Q]uickfix next' })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>', { desc = '[Q]uickfix [F]irst]' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>', { desc = '[Q]uickfix [L]ast' })

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move lines in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Reload configuration
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[V]im toggle [F]ormat' })
vim.keymap.set('n', '<leader>vn', toggle_number, { desc = '[V]im toggle [N]umber' })

return {}
