-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

local Job = require 'plenary.job'
-- vim.lsp.inlay_hint.enable(true)

-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

vim.o.wrap = false

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

vim.api.nvim_create_user_command('CdCurrentBufferDir', function()
  local path = vim.fn.expand '%:p:h'
  print('cd ' .. path)
  vim.api.nvim_set_current_dir(path)
end, {})

vim.api.nvim_create_user_command('CdGitRoot', function()
  Job:new({
    command = 'git',
    args = { 'rev-parse', '--show-toplevel' },
    cwd = '.',
    on_exit = function(j, return_val)
      local path = j:result()[1]
      vim.schedule(function()
        print('cd ' .. path)
        vim.api.nvim_set_current_dir(path)
      end)
    end,
  }):start()
end, {})

return {
  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', dependencies = { 'moll/vim-bbye' } },
}
