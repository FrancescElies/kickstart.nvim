local M = {}

M.open_with_default_app = function(path)
  local cmd

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

  vim.fn.jobstart(cmd, { detach = true })
end

return M
