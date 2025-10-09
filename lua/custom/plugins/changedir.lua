local Job = require 'plenary.job'

local function cdroot_of(opts)
  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = 'git',
    args = { 'rev-parse', '--show-toplevel' },
    cwd = opts.cwd,
    on_exit = function(j, _)
      local path = j:result()[1]
      vim.schedule(function()
        if path == nil then
          return
        end
        print('cwd: ' .. path)
        vim.api.nvim_set_current_dir(path)
      end)
    end,
  }):start()
end

vim.api.nvim_create_user_command('CdBufDir', function()
  local path = vim.fn.expand '%:p:h'
  print('cwd: ' .. path)
  vim.api.nvim_set_current_dir(path)
  -- vim.fn.chdir() maybe?
end, { desc = 'changes directory to current buffer dir' })

vim.api.nvim_create_user_command('CdBufRootDir', function()
  cdroot_of { cwd = vim.fn.expand '%:p:h' }
end, { desc = "changes dir to git's root (toplevel)" })

vim.keymap.set('n', 'cdd', ':CdBufDir<cr>', { desc = '[cd] buf [d]ir' })
vim.keymap.set('n', 'cd', ':CdBufRootDir<cr>', { desc = '[cd] buf root dir' })

-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = vim.api.nvim_create_augroup('my-cd', { clear = true }),
--   pattern = '*',
--   callback = function()
--     -- Only run for normal buffers, (no terminal, quickfix ...)
--     local filename = vim.fn.expand '%'
--     if vim.bo.buftype == '' and filename ~= '' and vim.fn.filereadable(filename) == 1 then
--       cdroot_of { cwd = vim.fn.expand '%:p:h' }
--     end
--   end,
-- })

return {}
