-- Commodity function to print stuff
function _G.p(v)
  print(vim.inspect(v))
end

vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.tabstop = 4
vim.opt.splitright = true
vim.opt.splitbelow = true

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

-- Move to next and previous buffer with ease
vim.keymap.set('n', '<M-B>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<M-b>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next tab' })

-- quickfix
vim.keymap.set('n', '<M-Q>', '<cmd>cprevious<cr>zz', { desc = 'QuickfiX previous' })
vim.keymap.set('n', '<M-q>', '<cmd>cnext<cr>zz', { desc = 'QuickfiX next' })
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>zz', { desc = 'QuickfiX previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zz', { desc = 'QuickfiX next' })
vim.keymap.set('n', '[l', '<cmd>lprevious<cr>zz', { desc = 'LocList previous' })
vim.keymap.set('n', ']l', '<cmd>lnext<cr>zz', { desc = 'LocList next' })
-- M-w just because is next to q
vim.keymap.set('n', '<M-W>', '<cmd>lprevious<cr>zz', { desc = 'LocList previous' })
vim.keymap.set('n', '<M-w>', '<cmd>lnext<cr>zz', { desc = 'LocList next' })

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
vim.keymap.set('n', '<leader>xf', '<cmd>w|source %<cr>', { desc = 'load [L]ua [f]ile' })
vim.keymap.set('n', '<leader>xl', '<cmd>.lua<cr>', { desc = 'load [L]ua [l]ine' })
vim.keymap.set('v', '<leader>x', ':lua<cr>', { desc = 'load [L]ua region' })

vim.keymap.set('n', '<leader>vm', ":new | put=execute('messages')<cr>", { desc = 'vim messages' })
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[v]im toggle [f]ormat' })
vim.keymap.set('n', '<leader>vd', toggle_inline_diagnostic, { desc = '[v]im toggle inline diagnostic' })
vim.keymap.set('n', '<leader>vs', ':set invhlsearch<cr>', { desc = '[v]im toggle highlight [s]earch' })
vim.keymap.set('n', '<leader>vS', ':set invspell<cr>', { desc = '[v]im toggle [S]pell' })

vim.keymap.set('', '<leader>vD', function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  else
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end
end, { desc = 'toggle diagnostic virtual text' })

return {}
