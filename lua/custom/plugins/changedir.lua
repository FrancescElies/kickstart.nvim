local Job = require 'plenary.job'

local function cdroot(opts)
  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = 'git',
    args = { 'rev-parse', '--show-toplevel' },
    cwd = opts.cwd,
    on_exit = function(j, _)
      local path = j:result()[1]
      vim.schedule(function()
        vim.api.nvim_set_current_dir(path)
      end)
    end,
  }):start()
end

vim.api.nvim_create_user_command('CdParent', function()
  local path = vim.fn.expand '%:p:h'
  vim.api.nvim_set_current_dir(path)
end, { desc = 'changes directory to files parent dir' })

vim.api.nvim_create_user_command('CdRoot', function()
  cdroot { cwd = vim.fn.expand '%:p:h' }
end, { desc = "changes dir to git's root (toplevel)" })

-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = vim.api.nvim_create_augroup('my-cd', { clear = true }),
--   pattern = '*',
--   callback = function()
--     cdroot { cwd = vim.fn.expand '%:p:h' }
--   end,
-- })

return {}
