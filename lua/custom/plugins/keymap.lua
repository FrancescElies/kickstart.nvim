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

-- local function jump_diagnostic_by_severity(opts)
--   local count = opts.count or 1
--   local severities = {
--     vim.diagnostic.severity.ERROR,
--     vim.diagnostic.severity.WARN,
--     vim.diagnostic.severity.INFO,
--     vim.diagnostic.severity.HINT,
--   }
--   for _, severity in ipairs(severities) do
--     local diagnostics = vim.diagnostic.get(0, { severity = severity })
--     if #diagnostics > 0 then
--       -- vim.diagnostic.goto_next { severity = severity }
--       vim.diagnostic.jump { count = count, float = true, severity = severity }
--       return
--     end
--   end
-- end
-- -- quickfix
-- local function is_quickfix_open()
--   return vim.fn.getqflist({ winid = 0 }).winid ~= 0
-- end
-- vim.keymap.set('n', '<C-p>', function()
--   if is_quickfix_open() then
--     vim.cmd 'cprevious' -- previous quickfix item
--     vim.cmd 'normal! zz'
--   else
--     -- vim.diagnostic.jump { count = -1, float = true }
--     jump_diagnostic_by_severity { count = -1 }
--   end
-- end)
-- vim.keymap.set('n', '<C-n>', function()
--   if is_quickfix_open() then
--     vim.cmd 'cnext' -- next quickfix item
--     vim.cmd 'normal! zz'
--   else
--     -- vim.diagnostic.jump { count = 1, float = true }
--     jump_diagnostic_by_severity { count = 1 }
--   end
-- end)
vim.keymap.set('n', '<C-h>', ':colder<cr>', { desc = 'open older error list' })
vim.keymap.set('n', '<C-l>', ':cnewer<cr>', { desc = 'open newer error list' })
vim.keymap.set('n', '<C-k>', ':cprev<cr>zz', { desc = 'previous error' })
vim.keymap.set('n', '<C-j>', ':cnext<cr>zz', { desc = 'next error' })

-- nav buffers and tabs
-- vim.keymap.set({ 'n', 't' }, '<M-x>', '<cmd>bd!<cr>')
-- vim.keymap.set('n', '<leader>bd', '<cmd>bp<bar>bd #<CR>', { desc = '[b]uffer [d]elete ' })
-- vim.keymap.set('n', '<leader>bo', '<cmd>%bd<bar>e#<cr>', { desc = '[b]uffer delete [o]thers' })
-- vim.keymap.set('n', '<leader>bs', '<cmd>w<cr>', { desc = '[b]uffer [s]ave' })
-- vim.keymap.set('n', '<leader>bn', '<cmd>new<cr>', { desc = '[b]uffer[n]ew ' })

-- -- loclist
-- vim.keymap.set('n', '<leader>lo', '<cmd>lopen<cr>zz', { desc = 'LocList open' })
-- vim.keymap.set('n', '<leader>lc', '<cmd>lclose<cr>zz', { desc = 'LocList close' })
-- vim.keymap.set('n', '<leader>lp', '<cmd>lprevious<cr>zz', { desc = 'LocList previous' })
-- vim.keymap.set('n', '<leader>lp', '<cmd>lnext<cr>zz', { desc = 'LocList next' })

vim.diagnostic.config { virtual_text = true, virtual_lines = false }

local function toggle_inline_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end

vim.o.spell = true

-- File
vim.keymap.set('n', '<leader>by', ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = '[b]uffer [y]ank path' })
vim.keymap.set('n', '<leader>bY', ":call setreg('+', expand('%:p'))<CR>", { desc = '[b]uffer [Y]ank abs. path' })
vim.keymap.set('n', '<leader>bo', ':e <C-r>+<CR>', { desc = '[b]uffer [o]pen from clipboard' })

-- quick scape
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', 'ı', 'i')

-- buffer
-- vim.keymap.set('n', 'so', '<cmd>e #<cr>', { desc = '[s]witch to [o]ther buffer' })
-- vim.keymap.set('n', 'ss', '<cmd>split<cr>', { desc = 'split' })
-- vim.keymap.set('n', 'sv', '<cmd>vsplit<cr>', { desc = 'vertical split' })
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Nop>')

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '*', '*zzzv')
vim.keymap.set('n', '#', '#zzzv')
vim.keymap.set('n', 'g*', 'g*zzzv')
vim.keymap.set('n', 'g#', 'g#zzzv')

-- Keep cursor in place when joining lines
-- vim.keymap.set('n', 'J', 'mzJ`z')

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

-- Reload configuration
vim.keymap.set('n', '<leader>lf', '<cmd>w|source %<cr>', { desc = 'load [L]ua [f]ile' })
vim.keymap.set('n', '<leader>ll', '<cmd>.lua<cr>', { desc = 'load [L]ua [l]ine' })
vim.keymap.set('v', '<leader>l', ':lua<cr>', { desc = 'load [L]ua region' })

vim.keymap.set('n', '<leader>vm', ":new | put=execute('messages')<cr>", { desc = 'vim messages' })
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[v]im [f]ormat toggle' })
vim.keymap.set('n', '<leader>vw', ':set invwrap<cr>', { desc = '[v]im [w]rap toggle' })
vim.keymap.set('n', '<leader>v/', ':set invhlsearch<cr>', { desc = '[v]im highlight [/]search toggle' })
vim.keymap.set('n', '<leader>vs', ':set invspell<cr>', { desc = '[v]im [S]pell toggle' })

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

-- vim.keymap.set('n', '<M->>', '<c-w>5<')
-- vim.keymap.set('n', '<M-<>', '<c-w>5>')
-- height
-- vim.keymap.set('n', '<M-.>', '<C-W>+')
-- vim.keymap.set('n', '<M-,>', '<C-W>-')

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'ZW', ':w<cr>')
vim.keymap.set('n', 'ZA', ':wa<cr>')
vim.keymap.set('n', 'ZS', ':w<cr>')

vim.keymap.set('n', 'su', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = 'substitute current word' })

vim.keymap.set({ 'n', 'v' }, '<leader>x', vim.lsp.buf.references, { buffer = true })
--
-- the end
--
return {}
