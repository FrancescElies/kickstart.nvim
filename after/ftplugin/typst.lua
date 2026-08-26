vim.keymap.set('n', '<localleader><localleader>', function()
  local file = vim.fn.expand '%:p'
  vim.cmd 'wall'
  local output = vim.fn.fnamemodify(file, ':r') .. '.pdf'
  vim.fn.jobstart({ 'typst', 'compile', file, output }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Typst compiled: ' .. output, vim.log.levels.INFO)
        local fn = require 'custom.fn'
        fn.open_in_system_default_app(output)
      else
        vim.notify('Typst compile failed (exit ' .. code .. ')', vim.log.levels.ERROR)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data and #data > 1 then vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR) end
    end,
  })
end, { buffer = 0, desc = 'Compile Typst to PDF' })
