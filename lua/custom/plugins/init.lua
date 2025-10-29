-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

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

vim.o.wrap = false

vim.o.swapfile = false

vim.o.inccommand = 'split'

-- Don't have `o` add a comment
vim.opt.formatoptions:remove 'o'

-- `gf` path shenaningan
-- vim.opt.isfname:append "'" -- allow single quotes
-- vim.opt.isfname:append '32' -- allow spaces in paths
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

local is_windows = string.lower(vim.loop.os_uname().sysname) == 'windows_nt'
if jit and is_windows then
  local ffi = require 'ffi'
  ffi.cdef [[ uint32_t SetThreadExecutionState(uint32_t esFlags); ]]
  local ES_CONTINUOUS = 0x80000000
  local ES_SYSTEM_REQUIRED = 0x00000001
  local ES_DISPLAY_REQUIRED = 0x00000002
  local kernel32 = ffi.load 'kernel32'

  vim.api.nvim_create_user_command('ScreenAliveOff', function()
    local ret = kernel32.SetThreadExecutionState(bit.bor(ES_CONTINUOUS))
    if ret == 0 then
      error 'Failed to reset thread execution state'
    else
      print 'Keep screen alive OFF'
    end
  end, {})

  vim.api.nvim_create_user_command('ScreenAliveOn', function()
    local ret = kernel32.SetThreadExecutionState(bit.bor(ES_CONTINUOUS, ES_SYSTEM_REQUIRED, ES_DISPLAY_REQUIRED))
    if ret == 0 then
      error 'Failed to set thread execution state'
    else
      print 'Keep screen alive ON '
    end
  end, {})
end

return {
  -- { 'm4xshen/hardtime.nvim', lazy = false, dependencies = { 'MunifTanjim/nui.nvim' }, opts = {} },
  -- { 'tris203/precognition.nvim', opts = {} },
  -- {
  --   'dmtrKovalenko/fff.nvim',
  --   build = function()
  --     require('fff.download').download_or_build_binary()
  --   end,
  --   lazy = false, -- This plugin initializes itself lazily.
  --   keys = {
  --     { 'ff', require('fff').find_files, desc = 'FFFind files' },
  --   },
  -- },
  -- { 'monaqa/dial.nvim', }
  -- hover.nvim
  -- spaceless.nvim
  -- unimpaired.nvim
  --
  -- connect to databases
  --  "tpope/vim-dadbod",
  -- "kristijanhusak/vim-dadbod-completion",
  -- "kristijanhusak/vim-dadbod-ui",
  -- guessindent
  -- octo.nvim
}
-- https://github.com/wezm/rsspls rrs please, make rss from website
-- https://github.com/wezm/titlecase titlecase - is a small tool and library (crate) that capitalizes English text according to a style defined by John Gruber
