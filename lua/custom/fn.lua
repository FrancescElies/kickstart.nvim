local M = {}

M.fun = function(t)
  local f = t[1]
  local args = { unpack(t, 2) }
  return function() return f(unpack(args)) end
end

M.fn = function(f, ...)
  local args = { ... }
  return function(...) return f(unpack(args), ...) end
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
M.gh = function(repo) return 'https://github.com/' .. repo end

M.run_build = function(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

M.open_in_system_default_app = function(path)
  local sysname = vim.loop.os_uname().sysname
  if sysname == 'Windows_NT' then
    os.execute(string.format('start "" "%s"', path))
  elseif sysname == 'Darwin' then
    os.execute(string.format('open "%s"', path))
  else
    os.execute(string.format('xdg-open "%s"', path))
  end
end

return M
