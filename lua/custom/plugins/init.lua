-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

vim.lsp.inlay_hint.enable(false)

-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

-- https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
-- Example:
-- :MyRedir =vim.lsp.get_active_clients()
vim.api.nvim_create_user_command('MyRedir', function(ctx)
  local result = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(result.output, '\n', { plain = true })
  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

-- https://github.com/neovim/neovim/pull/13896
-- Usage:
--   local r = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)
--   vim.print(region_to_text(r))
function region_to_text(region)
  local text = ''
  local maxcol = vim.v.maxcol
  for line, cols in vim.spairs(region) do
    local endcol = cols[2] == maxcol and -1 or cols[2]
    local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
    text = ('%s%s\n'):format(text, chunk)
  end
  return text
end

vim.o.wrap = false
vim.o.swapfile = false

-- Don't have `o` add a comment
vim.opt.formatoptions:remove 'o'

-- `gf` path shenaningan
-- vim.opt.isfname:append "'" -- allow single quotes
-- vim.opt.isfname:append '32' -- allow spaces in paths

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

return {}
