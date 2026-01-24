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

-- Ask nvim where variables last set:
-- :verbose setlocal ts? sts? et? sw?
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.splitright = true
vim.opt.splitbelow = true

-- NOTE: breaks <c-x><c-n> as it doesn't find inner words
-- vim.opt.iskeyword:append '-' -- helps vim-abolish to convert from kebab-case

vim.keymap.set('n', '<M-h>', ':bprev')
vim.keymap.set('n', '<M-l>', ':bnext')

-- cycle entries showing only the ones starting with current input
vim.keymap.set('c', '<C-k>', '<t_ku>', { desc = 'previous similar entry' })
vim.keymap.set('c', '<C-j>', '<t_kd>', { desc = 'next similar entry' })

vim.diagnostic.config { virtual_text = true, virtual_lines = false }

local function toggle_inline_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end

vim.o.spell = true
-- vim.o.spelllang = 'de_de,en_us'
--

-- for faster spelling corrections
vim.keymap.set('n', 'gz', ':silent! normal! [s1z=<cr>]s', { desc = "Fix previous spelling with first suggestion" })
vim.keymap.set('n', 'gzz', ':silent! norm! 1z=<cr>', { desc = "Exchange current word with first suggestion" })

-- File

vim.keymap.set('n', '<leader>by', function()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.fn.has 'win32' then
    name = name:gsub('/', '\\')
  end
  vim.fn.setreg('+', name)
end, { desc = '[b]uffer [y]ank path' })
vim.keymap.set('n', '<leader>bY', function()
  local abs_path = vim.fn.expand '%:p'
  if vim.fn.has 'win32' then
    abs_path = abs_path:gsub('/', '\\')
  end
  vim.fn.setreg('+', abs_path)
end, { desc = '[b]uffer [Y]ank abs. path' })
vim.keymap.set('n', '<leader>bo', ':e <C-r>+<CR>', { desc = '[b]uffer [o]pen from clipboard' })

-- quick scape
vim.keymap.set({ 'i', 'c' }, 'jk', '<Esc>')
vim.keymap.set({ 'n', 'i' }, '<C-c>', '<Esc>')

vim.keymap.set('n', 'ı', 'i')

-- [s]witch commands
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Nop>') -- disables default behaviour
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Nop>') -- disables default behaviour
vim.keymap.set('n', 'se', '<cmd>e #<cr>', { desc = '[s]witch to alternat[e]' })

vim.keymap.set('n', 'so', '<cmd>so %<cr>', { desc = '[s]ource current buffer' })
vim.keymap.set('n', 's.', '<cmd>.lua<cr>', { desc = '[s]ource current [l]ine' })

-- execute as shell command from cursor to EOL
vim.keymap.set('n', ',x', '"ey$:!<c-r>e<cr>', { desc = 'e[x]ecute line as shell command' })
-- execute as : command from cursor to EOL
vim.keymap.set('n', ',X', '"ey$:!<c-r>e<cr>', { desc = 'e[x]ecute line as vim command (:)' })

-- Keep things vertically centered during search
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '`', 'n.') -- n. is a common pattern, let's make it one key instead
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '*', '*zzzv')
vim.keymap.set('n', '#', '#zzzv')
vim.keymap.set('n', 'g*', 'g*zzzv')
vim.keymap.set('n', 'g#', 'g#zzzv')

-- easier step by step replace, repeat with single-repat `.`
vim.keymap.set('x', 'c*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>Ncgn]])
vim.keymap.set('n', 'c*', '*Ncgn')
vim.keymap.set('n', 'c#', '#Ncgn')
vim.keymap.set('n', 'cg*', 'g*Ncgn')
vim.keymap.set('n', 'cg#', 'g#Ncgn')
vim.keymap.set('n', 'dg*', '*Ndgn')

-- Keep cursor in place when joining lines
-- vim.keymap.set('n', 'J', 'mzJ`z')

-- how to choose bindings for commands that modify text: http://vimcasts.org/blog/2014/02/follow-my-leader/
vim.keymap.set({ 'n', 'v' }, 'ysS', ':s/\\\\/\\//g<cr>', { desc = '[y]ou [s]ubstitute back[S]lash \\ -> /' })
vim.keymap.set({ 'n', 'v' }, 'yss', ':s/\\//\\\\/g<cr>', { desc = '[y]ou [s]ubstitute [s]lash / -> [\\]' })

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

vim.keymap.set('n', '<leader>ve', ':e $MYVIMRC', { desc = 'edit vimrc' })

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

vim.keymap.set({ 'n', 'v' }, 's/', [[:s,/,\\,g<cr>]], { desc = 'substitute / with \\' })
vim.keymap.set({ 'n', 'v' }, 's\\', [[:s,\\,/,g<cr>]], { desc = 'substitute \\ with /' })
vim.keymap.set('n', 'su', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = 'substitute current word' })
vim.keymap.set('n', 'sU', [[:%S/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = 'substitute current word' })

vim.keymap.set({ 'n', 'v' }, '<leader>x', vim.lsp.buf.references, { buffer = true })

-- QUICKLY EDIT YOUR MACROS: https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
-- Also:
--   "qp paste the contents of the register to the current cursor position
--   add the missing motion, then <Esc> return to visual mode
--   "qyy yank this new modified macro back into the q register
-- vim.keymap.set(
--   'n',
--   '<leader>m',
--   ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>p",
--   { desc = 'edit macro, e.g. "q<leader>m' }
-- )

--
-- the end
--
return {}
