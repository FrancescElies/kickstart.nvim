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

local function toggle_inline_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

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

-- File
vim.keymap.set('n', '<leader>fy', ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = '[f]ilepath: [y]ank' })
vim.keymap.set('n', '<leader>fY', ":call setreg('+', expand('%:p'))<CR>", { desc = '[f]ilepath: [Y]ank (absolute)' })
vim.keymap.set('n', '<Leader>fo', ':e <C-r>+<CR>', { desc = '[f]ilepath: [o]pen from clipboard' })

-- quick scape
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', 'ı', 'i')

-- quick spellfix
vim.keymap.set('n', 'za', '1z=', { desc = 'fix word under cursor' }) --  https://nanotipsforvim.prose.sh/autofix-misspellings

-- buffer
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

-- Move to next and previous buffer with ease
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- quickfix
vim.keymap.set('n', '<M-X>', '<cmd>cprevious<cr>zz', { desc = 'QuickfiX previous' })
vim.keymap.set('n', '<M-x>', '<cmd>cnext<cr>zz', { desc = 'QuickfiX next' })
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>zz', { desc = 'Quickfix previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zz', { desc = 'Quickfix next' })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>zz', { desc = 'Quickfix First' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>zz', { desc = 'Quickfix Last' })

-- Keep things vertically centered during searches
-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move lines in visual mode
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<leader>r/', ':s/\\\\/\\//g<cr>', { desc = 'Replace \\ -> /' })
vim.keymap.set('v', '<leader>r\\', ':s/\\//\\\\/g<cr>', { desc = 'Replace / -> [\\]' })

-- https://github.com/nvim-telescope/telescope.nvim/issues/1923
function vim.getVisualSelection()
  local current_clipboard_content = vim.fn.getreg '"'

  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg 'v'
  vim.fn.setreg('v', {})

  vim.fn.setreg('"', current_clipboard_content)

  text = string.gsub(text, '\n', '')
  if #text > 0 then
    return text
  else
    return ''
  end
end

-- Reload configuration
vim.keymap.set('n', '<leader>l', ':luafile %<cr>', { desc = 'load Luafile' })
vim.keymap.set('n', '<leader>tf', ':FormatToggle<CR>', { desc = 'toggle Format' })
vim.keymap.set('n', '<leader>vm', ":new | put=execute('messages')<cr>", { desc = 'Vim messages' })
vim.keymap.set('n', '<leader>tn', toggle_number, { desc = 'toggle line Number' })
vim.keymap.set('n', '<leader>ti', toggle_inline_diagnostic, { desc = 'toggle inline Diagnostic' })
vim.keymap.set('n', '<leader>ts', ':set invhlsearch<cr>', { desc = 'toggle Highlight search' })
vim.keymap.set('n', '<leader>tS', ':set invspell<cr>', { desc = 'toggle Spell' })

-- Terminal Mappings
-- vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
-- vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
-- vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
-- vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
-- vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
-- vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
-- vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })
return {}
