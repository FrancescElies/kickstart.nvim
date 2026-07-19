local fn = require 'custom.fn'

-- vim
-- ├── api        (core engine)
-- ├── fn         (vimscript bridge)
-- ├── cmd        (command layer)
-- ├── fs         (filesystem)
-- ├── loop       (OS + async)
-- ├── opt        (options)
-- ├── keymap     (mappings)
-- ├── lsp        (language server)
-- ├── diagnostic (errors/warnings)
-- ├── treesitter (syntax)
-- └── ui         (user interaction)

vim.lsp.inlay_hint.enable(false)

-- https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
-- Example:
-- :Redir =vim.lsp.get_active_clients()
vim.api.nvim_create_user_command('Redir', function(ctx)
  local result = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(result.output, '\n', { plain = true })
  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

local list_snips = function()
  local ft_list = require('luasnip').available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end
vim.api.nvim_create_user_command('SnipList', list_snips, {})

vim.o.wrap = false
vim.o.showbreak = '>> '

vim.o.swapfile = false

vim.o.inccommand = 'split'

vim.o.linebreak = true -- don't break words when wrapping

-- Don't have `o` add a comment
vim.opt.formatoptions:remove 'o'

-- Add a border to all floating windows (hover docs, signature help, diagnostics)
vim.o.winborder = 'rounded'

local is_win32 = vim.fn.has 'win32' == 1
-- `gf` path shenaningans
if is_win32 then
  vim.opt.isfname:append "'" -- allow single quotes
  vim.opt.isfname:append '32' -- allow spaces in paths
end
vim.opt.isfname:append '@'

vim.o.complete = '.,w,b,u,t,i,kspell'

-- Folds
-- za                | Toggle fold
-- zA                | Toggle fold recursively
-- zc                | Close fold
-- zo                | Open fold
-- zM                | Close **all** folds
-- zR                | Open **all** folds
-- zm / zr           | Increase/decrease fold level
-- :set foldenable   | Enable folding
-- :set nofoldenable | Disable folding
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldopen:remove 'block' -- avoid fold opening when moving {, [[ ...

if vim.env.SSH_CONNECTION then
  local function vim_paste()
    local content = vim.fn.getreg '"'
    return vim.split(content, '\n')
  end

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = vim_paste,
      ['*'] = vim_paste,
    },
  }
end

vim.opt.diffopt:append {
  'internal', -- built-in diff engine (faster, supports fine-grained diffs)
  'algorithm:patience', -- better for readable diffs (especially for reordered blocks)
  'indent-heuristic', -- improves diffs when indentation changes
  'linematch:60', -- enables intraline (word-level) diff matching on similar lines (up to 60 chars difference allowed
}

vim.api.nvim_create_user_command('Dec2Hex', function()
  local cword = vim.fn.expand '<cword>'
  local num = tonumber(cword)
  if num then
    local hex = string.format('0x%X', num)
    vim.cmd('normal! ciw' .. hex)
  else
    print 'Not a valid number under cursor'
  end
end, {})

vim.api.nvim_create_user_command('SwapHexEndianness', function()
  local word = vim.fn.expand '<cword>'

  if not word:match '^0x[0-9A-Fa-f]+$' or #word % 2 ~= 0 then
    print('Not a hex word: ' .. word)
    return
  end

  local bytes = {}
  for i = 3, #word, 2 do
    table.insert(bytes, word:sub(i, i + 1))
  end
  table.insert(bytes, '0x')

  local swapped = table.concat(vim.fn.reverse(bytes))

  vim.cmd('normal! ciw' .. swapped)
end, {})

vim.api.nvim_create_user_command('ExecuteAfterXMinutes', function(opts)
  local minutes = tonumber(opts.fargs[1])
  local command = table.concat(opts.fargs, ' ', 2)
  local millis = minutes * 60 * 1000

  vim.defer_fn(function() vim.cmd(command) end, millis)
end, {})

---@type table<string, uv.uv_timer_t|nil>
local timers = {
  every_x_min = nil,
}

vim.api.nvim_create_user_command('ExecuteEveryXMinutes', function(opts)
  local minutes = tonumber(opts.fargs[1])
  local millis = minutes * 60 * 1000
  local command = table.concat(opts.fargs, ' ', 2)
  timers.every_x_min = vim.loop.new_timer()
  timers.every_x_min:start(millis, 0, wiggle_mouse)
end, {})

vim.api.nvim_create_user_command('ExecuteEveryXMinutesCancel', function(opts)
  if timers.every_x_min ~= nil then timers.every_x_min:stop() end
end, {})

vim.keymap.set('v', '<localleader>s', ':!codesort', { desc = 'codesort' })
vim.keymap.set('n', '<localleader>s', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1]
  local cmd = string.format('%%!codesort --around %d --detect %s', line, vim.fn.shellescape(vim.fn.expand '%:t'))
  vim.cmd(cmd)
  vim.api.nvim_win_set_cursor(0, cursor_pos) -- restore cursor
end, { desc = 'codesort optimal range around the current line', silent = true })

vim.api.nvim_create_user_command('SetIndentationConfig', function(opts)
  local mode = opts.fargs[1]
  local width = tonumber(opts.fargs[2])
  if mode == 'tabs' then
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 0
    vim.opt.softtabstop = width
    vim.opt.tabstop = width
  else
    vim.opt.expandtab = true
    vim.opt.shiftwidth = width
    vim.opt.tabstop = width
  end
end, {
  nargs = '*',
  desc = 'configure tab/space behavior',
  complete = function(arg_lead, full_line, pos)
    local args_so_far = vim.split(full_line, '%s+', { trimempty = true })
    table.remove(args_so_far, 1) -- remove the command name

    if #args_so_far == 0 then return { 'tabs', 'spaces' } end

    if #args_so_far == 1 then return { '2', '4', '8' } end

    return {}
  end,
})

local function async_make(opts)
  local cmd = opts.args ~= '' and opts.args or 'zig build'
  local tmpfile = vim.fn.tempname()

  vim.fn.jobstart({ cmd }, {
    on_exit = function(job_id, code, event)
      vim.schedule(function()
        vim.cmd('cfile ' .. tmpfile)
        vim.cmd 'copen'
        if code == 0 then
          vim.notify('Build successful!', vim.log.levels.INFO)
        else
          vim.notify('Build failed with code ' .. code, vim.log.levels.ERROR)
        end
      end)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(job_id, data, event)
      -- Write stdout to file
      vim.fn.writefile(data, tmpfile, 'a')
    end,
    on_stderr = function(job_id, data, event)
      -- Write stderr to file
      vim.fn.writefile(data, tmpfile, 'a')
    end,
  })
end

vim.api.nvim_create_user_command('AsyncMake', async_make, {
  nargs = '?',
  complete = 'shellcmd',
})

vim.api.nvim_create_user_command('LspDetach', function(opts)
  local name = opts.args
  local clients = vim.lsp.get_clients { name = name }
  for _, client in ipairs(clients) do
    vim.lsp.buf_detach_client(0, client.id)
  end
end, {
  nargs = 1,
  desc = 'Detches lsp client from current buffer',
  complete = function(arg_lead, _, _)
    local unique_clients = {}
    local clients = {}
    for _, client in ipairs(vim.lsp.get_clients {}) do
      if unique_clients[client.name] ~= nil then table.insert(clients, client.name) end
      unique_clients[client.name] = true
    end

    if #arg_lead == 0 then return clients end

    local match = vim.fn.matchfuzzy(clients, arg_lead) -- Fuzzy filter based on partial input
    return match
  end,
})

vim.pack.add {
  fn.gh 'danymat/neogen',
  fn.gh 'tpope/vim-abolish', -- :help abolish, :%S/box{,es}/bag{,s}/g   crc crs cr. cru crk
  -- fn.gh 'tpope/vim-rsi', -- :help rsi, provides Readline (Emacs) mappings for insert and command line
  fn.gh 'nvim-mini/mini.bracketed', -- Configurable Lua functions to go forward/backward to a certain target
  -- fn.gh 'tpope/vim-repeat'
  -- fn.gh 'wincent/loupe'
  -- fn.gh 'kevinhwang91/nvim-hlslens'
  -- fn.gh 'godlygeek/tabular'
}

-- Iterate over all Lua files in the plugins directory and load them
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end

vim.filetype.add { extension = { jsonl = 'json' } }
vim.treesitter.language.register('json', 'jsonl')

vim.pack.add { fn.gh 'monaqa/dial.nvim' }
local dial = require 'dial.map'
vim.keymap.set('n', '<C-a>', function() dial.manipulate('increment', 'normal') end)
vim.keymap.set('n', '<C-x>', function() dial.manipulate('decrement', 'normal') end)
vim.keymap.set('n', 'g<C-a>', function() dial.manipulate('increment', 'gnormal') end)
vim.keymap.set('n', 'g<C-x>', function() dial.manipulate('decrement', 'gnormal') end)
vim.keymap.set('x', '<C-a>', function() dial.manipulate('increment', 'visual') end)
vim.keymap.set('x', '<C-x>', function() dial.manipulate('decrement', 'visual') end)
vim.keymap.set('x', 'g<C-a>', function() dial.manipulate('increment', 'gvisual') end)
vim.keymap.set('x', 'g<C-x>', function() dial.manipulate('decrement', 'gvisual') end)

-- connect to databases "tpope/vim-dadbod",
-- https://github.com/wezm/rsspls rrs please, make rss from website
-- https://github.com/wezm/titlecase titlecase - is a small tool and library (crate) that capitalizes English text according to a style defined by John Gruber
