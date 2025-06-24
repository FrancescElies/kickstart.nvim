--
-- Find where a map was last defined
--
-- :verbose map <key>
-- :verbose nmap <key>
--

-- Commodity function to print stuff
function _G.p(v)
  print(vim.inspect(v))
end

vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.tabstop = 4
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end)

vim.diagnostic.config { virtual_text = true, virtual_lines = false }

vim.keymap.set('n', '<leader>m', require('telescope.builtin').marks, { desc = '[m]arks' })

local function toggle_inline_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
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
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', 'ss', '<cmd>split<cr>', { desc = 'split' })
vim.keymap.set('n', 'sv', '<cmd>vsplit<cr>', { desc = 'vertical split' })

-- Move to next and previous buffer with ease
-- Quick buffer switching
vim.keymap.set('n', '<S-l>', ':bnext<CR>')
vim.keymap.set('n', '<S-h>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next tab' })

-- quickfix
local function is_quickfix_open()
  return vim.fn.getqflist({ winid = 0 }).winid ~= 0
end
vim.keymap.set('n', '<C-p>', function()
  if is_quickfix_open() then
    vim.cmd 'cprevious' -- previous quickfix item
    vim.cmd 'normal! zz'
  else
    vim.cmd 'normal [c' -- next change
  end
end)
vim.keymap.set('n', '<C-n>', function()
  if is_quickfix_open() then
    vim.cmd 'cnext' -- next quickfix item
    vim.cmd 'normal! zz'
  else
    vim.cmd 'normal ]c' -- previous change
  end
end)

-- -- loclist
-- vim.keymap.set('n', '<leader>lo', '<cmd>lopen<cr>zz', { desc = 'LocList open' })
-- vim.keymap.set('n', '<leader>lc', '<cmd>lclose<cr>zz', { desc = 'LocList close' })
-- vim.keymap.set('n', '<leader>lp', '<cmd>lprevious<cr>zz', { desc = 'LocList previous' })
-- vim.keymap.set('n', '<leader>lp', '<cmd>lnext<cr>zz', { desc = 'LocList next' })

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor in place when joining lines
vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set({ 'n', 'v' }, '<leader>r\\', ':s/\\\\/\\//g<cr>', { desc = 'Replace \\ -> /' })
vim.keymap.set({ 'n', 'v' }, '<leader>r/', ':s/\\//\\\\/g<cr>', { desc = 'Replace / -> [\\]' })

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

-- Open current file in external program
vim.keymap.set('n', '<leader>o', ':!open %<CR>', { desc = '[o]pen in external program' })

-- Reload configuration
vim.keymap.set('n', '<leader>lf', '<cmd>w|source %<cr>', { desc = 'load [L]ua [f]ile' })
vim.keymap.set('n', '<leader>ll', '<cmd>.lua<cr>', { desc = 'load [L]ua [l]ine' })
vim.keymap.set('v', '<leader>l', ':lua<cr>', { desc = 'load [L]ua region' })

vim.keymap.set('n', '<leader>vc', '<cmd>TSContext toggle<cr>', { desc = '[v]im TS [c]ontext toggle ' })
vim.keymap.set('n', '<leader>vm', ":new | put=execute('messages')<cr>", { desc = 'vim messages' })
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[v]im [f]ormat toggle' })
vim.keymap.set('n', '<leader>vs', ':set invhlsearch<cr>', { desc = '[v]im highlight [s]earch toggle' })
vim.keymap.set('n', '<leader>vS', ':set invspell<cr>', { desc = '[v]im [S]pell toggle' })

vim.keymap.set('n', '<leader>vd', toggle_inline_diagnostic, { desc = '[v]im [D]iagnostic toggle' })
vim.keymap.set('', '<leader>vv', function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  else
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end
end, { desc = '[v]im diagnostic [v]irtual text toggle ' })

-- control splits size  <>., are on the same two keys
-- width

vim.keymap.set('n', '<M->>', '<c-w>5<')
vim.keymap.set('n', '<M-<>', '<c-w>5>')
-- height
vim.keymap.set('n', '<M-.>', '<C-W>+')
vim.keymap.set('n', '<M-,>', '<C-W>-')

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

--
-- Neovide
--
if vim.g.neovide then
  local copy_key = '<C-S-C>'
  local paste_key = '<C-S-V>'

  vim.keymap.set('v', copy_key, '"+y') -- Copy
  vim.keymap.set('n', paste_key, '"+P') -- Paste normal mode
  vim.keymap.set('v', paste_key, '"+P') -- Paste visual mode
  vim.keymap.set('c', paste_key, '<C-R>+') -- Paste command mode
  vim.keymap.set('i', paste_key, '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<M-=>', function()
    change_scale_factor(1.10)
  end)
  vim.keymap.set('n', '<M-->', function()
    change_scale_factor(1 / 1.10)
  end)
  vim.keymap.set('n', '<M-0>', function()
    vim.g.neovide_scale_factor = 1.0
  end)

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', paste_key, '+p<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('!', paste_key, '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', paste_key, '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', paste_key, '<C-R>+', { noremap = true, silent = true })
end

--
-- the end
--
return {}
