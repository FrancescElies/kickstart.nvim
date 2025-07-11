local M = {}

M.open_with_default_app = function(path)
  -- alternative implementation
  -- local cmd = vim.fn.has 'win32' == 1 and 'start' or vim.fn.has 'mac' == 1 and 'open' or 'xdg-open'
  -- ---@diagnostic disable-next-line: missing-fields
  -- require('plenary.job'):new({ command = cmd, args = { entry.value } }):start()
  local cmd

  path = vim.fs.normalize(path)

  if vim.fn.has 'mac' == 1 then
    cmd = { 'open', path }
  elseif vim.fn.has 'unix' == 1 then
    cmd = { 'xdg-open', path }
  elseif vim.fn.has 'win32' == 1 then
    cmd = { 'cmd.exe', '/C', 'start', '', path }
  else
    print 'Unsupported system'
    return
  end

  print(table.concat(cmd, ' '))
  vim.fn.jobstart(cmd, { detach = true })
end

return M
