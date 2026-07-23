--
-- Find where a map was last defined
--
-- :verbose map <key>
-- :verbose nmap <key>
--

-- Commodity function to print stuff
function _G.p(v) print(vim.inspect(v)) end

-- Ask nvim where variables last set:
-- :verbose setlocal ts? sts? et? sw?
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.splitright = true
vim.opt.splitbelow = true

-- NOTE: breaks <c-x><c-n> as it doesn't find inner words
-- vim.opt.iskeyword:append '-' -- helps vim-abolish to convert from kebab-case

-- cycle entries showing only the ones starting with current input
vim.keymap.set('c', '<C-k>', '<t_ku>', { noremap = true, desc = 'previous similar entry' })
vim.keymap.set('c', '<C-j>', '<t_kd>', { desc = 'next similar entry' })

vim.o.spell = true
-- vim.o.spelllang = 'de_de,en_us'
--

-- for faster spelling corrections
vim.keymap.set('n', 'yc', ':silent! normal! [s1z=<cr>', { desc = '[y]ou [c]orrect spell [p]revious' })
-- vim.keymap.set('n', 'yC', ':silent! norm! 1z=<cr>', { desc = '[y]ou [c]orrect spell [.]current' })

-- File
local is_windows = vim.uv.os_uname().sysname == 'Windows_NT'
local function yank_path()
  local path = vim.api.nvim_buf_get_name(0)
  if is_windows then path = path:gsub('/', '\\') end
  vim.fn.setreg('+', path)
end
local function yank_abs_path()
  local path = vim.fn.expand '%:p'
  if is_windows then path = path:gsub('/', '\\') end
  vim.fn.setreg('+', path)
end
local function yank_just_name()
  local path = vim.fn.expand '%:t'
  if is_windows then path = path:gsub('/', '\\') end
  vim.fn.setreg('+', path)
end


vim.keymap.set('n', '<leader>byp', yank_path, { desc = '[b]uffer [y]ank [p]ath' })
vim.keymap.set('n', '<leader>bya', yank_abs_path, { desc = '[b]uffer [y]ank [a]bsolute path' })
vim.keymap.set('n', '<leader>byn', yank_just_name, { desc = '[b]uffer [y]ank [n]ame' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'delete buffer' })

-- quick scape
vim.keymap.set({ 'i', 'c' }, 'jk', '<Esc>')
vim.keymap.set({ 'i', 'c' }, ',.', '<Enter>')
vim.keymap.set({ 'n', 'i' }, '<C-c>', '<Esc>')

vim.keymap.set('n', 'ı', 'i')

-- [s] does the same as `cl`and is used by other plugins like mini surround, thus disabling it
-- Minisurround uses `sa` `sd` `sr` `sf` to manipulate and move to surrounding items
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Nop>') -- disables default behaviour
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Nop>') -- disables default behaviour
vim.keymap.set('n', 'se', '<cmd>e #<cr>', { desc = '[s]witch to alternat[e]' })

-- Commands Quick Execution
-- lua
vim.keymap.set('n', '<leader>lf', '<cmd>source %<CR>', { desc = '[l]ua source [f]ile' })
vim.keymap.set('n', '<leader>lb', '<cmd>so %<cr>', { desc = '[l]ua source current buffer' })
vim.keymap.set('v', '<leader>l', "<cmd>'<,'>lua<CR>", { desc = '[l]ua source selection' })
vim.keymap.set('n', '<leader>ll', '<cmd>.lua<cr>', { desc = '[l]ua source current [l]ine' })
-- :
vim.keymap.set('n', '<leader>le', '"ey$:!<c-r>e<cr>', { desc = '[l]ua source vim command (:) to [e]nd of line' })

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
vim.keymap.set('n', 'grr', 'grrzzzv') -- center after going to reference

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
vim.keymap.set({ 'n', 'v' }, 'ys\\', ':s/\\\\/\\//g<cr>', { desc = '[y]ou [s]ubstitute back[S]lash \\ -> /' })
vim.keymap.set({ 'n', 'v' }, 'ys/', ':s/\\//\\\\/g<cr>', { desc = '[y]ou [s]ubstitute [s]lash / -> [\\]' })

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

local function open_vim_pack_dir() vim.cmd('e ' .. vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'pack', 'core', 'opt')) end
vim.api.nvim_create_user_command('OpenVimPackDir', open_vim_pack_dir, {})

vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'delete (no yank)' })
-- vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'paste from clipboard' })

vim.keymap.set('n', '<leader>ve', '<cmd>tabnew | e $MYVIMRC | CdBufRootDir <cr>', { desc = 'edit vimrc' })
vim.keymap.set('n', '<leader>vp', open_vim_pack_dir, { desc = 'edit vimrc' })
vim.keymap.set('n', '<leader>vm', "<cmd>new | put=execute('messages')<cr>", { desc = 'vim messages' })

vim.keymap.set('n', '<leader>tr', '<cmd>set invrelativenumber<cr>', { desc = '[t]oggle [r]elativenumber' })
vim.keymap.set('n', '<leader>tw', '<cmd>set invwrapscan<cr>', { desc = '[t]oggle search [w]rap-around' })
vim.keymap.set('n', '<leader>tw', '<cmd>set invwrap<cr>', { desc = '[t]oggle [w]rap' })
vim.keymap.set('n', '<leader>ts', '<cmd>set invhlsearch<cr>', { desc = '[t]oggle highlight [s]earch' })
vim.keymap.set('n', '<leader>tS', '<cmd>set invspell<cr>', { desc = '[t]oggle [S]pell' })
vim.keymap.set('n', '<leader>ti', '<cmd>set invignorecase<cr>', { desc = '[t]oggle [i]gnorecase' })
vim.keymap.set('n', '<leader>tL', '<cmd>set invlist<cr>', { desc = '[t]oggle [l]ist (show invisible chars)' })

-- control splits size  <>., are on the same two keys
-- width

-- vim.keymap.set('n', '<M->>', '<c-w>5<')
-- vim.keymap.set('n', '<M-<>', '<c-w>5>')
-- height
-- vim.keymap.set('n', '<M-.>', '<C-W>+')
-- vim.keymap.set('n', '<M-,>', '<C-W>-')

vim.keymap.set('n', 'H', '<cmd>bprevious<CR>', { desc = 'prev buffer' })
vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'next buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>vs<cr><c-f>:set scb<cr><c-w>h<cmd>set scb<cr>', { desc = '[b]uf split & [c]ontinue view, (undo `:set noscb`)' })

-- Move lines in visual mode
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'move line up' })
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'move line down' })

vim.keymap.set({ 'n', 'v' }, 's/', [[:s,/,\\,g<cr>]], { desc = 'substitute / with \\' })
vim.keymap.set({ 'n', 'v' }, 's\\', [[:s,\\,/,g<cr>]], { desc = 'substitute \\ with /' })
vim.keymap.set({ 'n', 'v' }, 'ysu', [[:.,$s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = '[y]ou [s]ubstitute cur. word' })
vim.keymap.set({ 'n', 'v' }, 'ySu', [[:.,$S/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = '[y]ou [s]ubstitute cur. word' })

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
