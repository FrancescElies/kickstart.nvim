-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.tabstop = 4
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set('n', '<leader>m', require('telescope.builtin').marks, { desc = '[m]arks' })

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

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<C-S-k>', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<C-S-j>', '<cmd>lprev<CR>zz')

-- File
vim.keymap.set('n', '<leader>fy', ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = 'Filepath Yank/copy' })
-- vim.keymap.set('n', '<Leader>fo', ':e <C-r>+<CR>', { desc = 'Filepath Open from clipboard' })

-- quick scape
vim.keymap.set('i', 'jk', '<Esc>')

-- quick spellfix
vim.keymap.set('n', 'za', '1z=') -- fix word under cursor https://nanotipsforvim.prose.sh/autofix-misspellings

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
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>zz', { desc = 'Quickfix previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zz', { desc = 'Quickfix next' })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>zz', { desc = 'Quickfix First' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>zz', { desc = 'Quickfix Last' })

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move lines in visual mode
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<leader>/', ':s/\\\\/\\//g<cr>', { desc = 'Replace \\ -> /' })
vim.keymap.set('v', '<leader>\\', ':s/\\//\\\\/g<cr>', { desc = 'Replace / -> [\\]' })

-- Reload configuration
vim.keymap.set('n', '<leader>vl', ':luafile %<cr>', { desc = 'Vim load Luafile' })
vim.keymap.set('n', '<leader>ve', ':edit $MYVIMRC<cr>', { desc = 'Vim edit config' })
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = 'Vim toggle Format' })
vim.keymap.set('n', '<leader>vn', toggle_number, { desc = 'Vim toggle line Number' })
vim.keymap.set('n', '<leader>vs', ':set invspell<cr>', { desc = 'Vim toggle Spell' })
vim.keymap.set('n', '<leader>vh', ':set invhlsearch<cr>', { desc = 'Highlight search' })

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })
return {}
