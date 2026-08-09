vim.keymap.set('n', '<localleader><localleader>', function()
  local file = vim.fn.expand '%:p'
  vim.cmd 'write'
  local output = vim.fn.fnamemodify(file, ':r') .. '.html'
  vim.fn.jobstart({ 'makurust', file }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('makurust: ' .. output, vim.log.levels.INFO)
        local fn = require 'custom.fn'
        fn.open_in_system_default_app(output)
      else
        vim.notify('makurust failed (exit ' .. code .. ')', vim.log.levels.ERROR)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data and #data > 1 then vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR) end
    end,
  })
end, { buffer = 0, desc = 'Compile markdown to html' })
