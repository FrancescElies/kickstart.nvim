local Job = require 'plenary.job'

vim.api.nvim_create_user_command('CdBufParentDir', function()
  local path = vim.fn.expand '%:p:h'
  print('cd ' .. path)
  vim.api.nvim_set_current_dir(path)
end, {})
vim.keymap.set('n', '<leader>bcd', '<cmd>CdBufParentDir<cr>', { desc = '[b]uffer [cd] current dir' })

vim.api.nvim_create_user_command('CdBufGitRoot', function()
  vim.cmd.CdBufParentDir()
  vim.cmd.CdGitRoot()
end, {})
vim.keymap.set('n', '<leader>bcg', '<cmd>CdBufGitRoot<cr>', { desc = '[b]uffer [c]d [g]it root' })

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

-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = vim.api.nvim_create_augroup('my-cd', { clear = true }),
--   pattern = '*',
--   callback = function()
--     vim.cmd.CdBufGitRoot()
--   end,
-- })

return {}
