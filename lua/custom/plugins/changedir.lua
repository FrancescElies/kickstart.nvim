local Job = require 'plenary.job'

vim.api.nvim_create_user_command('CdBufParentDir', function()
  local path = vim.fn.expand '%:p:h'
  print('cd ' .. path)
  vim.api.nvim_set_current_dir(path)
end, {})

vim.api.nvim_create_user_command('CdBufGitRoot', function()
  vim.cmd.CdBufParentDir()
  vim.cmd.CdGitRoot()
end, {})

vim.api.nvim_create_user_command('CdGitRoot', function()
  ---@diagnostic disable-next-line: missing-fields
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

-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = vim.api.nvim_create_augroup('my-cd', { clear = true }),
--   pattern = '*',
--   callback = function()
--     vim.cmd.CdBufGitRoot()
--   end,
-- })

return {}
