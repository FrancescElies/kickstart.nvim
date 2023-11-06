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

vim.o.spell = true
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

-- buffer
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

-- Move to next and previous buffer with ease
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- quickfix
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>zz', { desc = '[Q]uickfix previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zz', { desc = '[Q]uickfix next' })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>zz', { desc = '[Q]uickfix [F]irst]' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>zz', { desc = '[Q]uickfix [L]ast' })

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move lines in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<leader>/', ':s/\\\\/\\//g<cr>', { desc = '[R]eplace \\ -> [/]' })
vim.keymap.set('v', '<leader>\\', ':s/\\//\\\\/g<cr>', { desc = '[R]eplace / -> [\\]' })

-- Reload configuration
vim.keymap.set('n', '<leader>vi', ':FormatToggle<CR>', { desc = '[V]im toggle D[i]agnostic' })
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[V]im toggle [F]ormat' })
vim.keymap.set('n', '<leader>vn', toggle_number, { desc = '[V]im toggle line [N]umber' })
vim.keymap.set('n', '<leader>vs', ':set invspell<cr>', { desc = '[V]im toggle [S]pell' })

-- tabs
vim.keymap.set('n', '<leader>tl', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader>tf', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<cr>', { desc = '[D]elete/Close Tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })
return {}
