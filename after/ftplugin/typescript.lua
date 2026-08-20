local function start_npm_run_build(opts)
  vim.fn.jobstart({ 'npm', 'run', 'build' }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('npm run build: ok', vim.log.levels.INFO)
      else
        vim.notify('num run build failed ' .. ' (exit ' .. code .. ')', vim.log.levels.ERROR)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data and #data > 1 then vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR) end
    end,
  })
end

vim.keymap.set('n', '<localleader><localleader>', '<cmd>MarkdownToHtml<cr>', { buffer = 0, desc = 'Compile markdown to html' })
