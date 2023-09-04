vim.api.nvim_create_augroup('bufcheck', { clear = true })

-- reload config file on change
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'bufcheck',
  pattern = vim.env.MYVIMRC,
  command = 'silent source %',
})

-- start terminal in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
  group = 'bufcheck',
  pattern = '*',
  command = 'startinsert | set winfixheight',
})

-- start git messages in insert mode
vim.api.nvim_create_autocmd('FileType', {
  group = 'bufcheck',
  pattern = { 'gitcommit', 'gitrebase' },
  command = 'startinsert | 1',
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'bufcheck',
  pattern = '*',
  callback = function()
    if vim.fn.line '\'"' > 0 and vim.fn.line '\'"' <= vim.fn.line '$' then
      vim.fn.setpos('.', vim.fn.getpos '\'"')
      -- vim.cmd('normal zz') -- how do I center the buffer in a sane way??
      vim.cmd 'silent! foldopen'
    end
  end,
})

function get_buffer_by_name_or_scratch(name, clean)
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.fn.bufname(buffer)
    if buf_name == name then
      if clean then
        vim.api.nvim_buf_set_lines(buffer, -0, -1, false, {})
      end
      -- buffer found
      return buffer
    end
  end

  -- buffer not found
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buffer, name)
  return buffer
end

function string_not_empty(str)
  -- Remove leading and trailing whitespace using the gsub function
  local trimmedStr = str:gsub('^%s*(.-)%s*$', '%1')

  -- Check if the trimmed string is empty
  if trimmedStr == '' then
    return false
  else
    return true
  end
end

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('MyTypescript', { clear = true }),
  pattern = '*.ts',
  callback = function()
    local buffer = get_buffer_by_name_or_scratch 'typescript output'
    local window = vim.api.nvim_get_current_win()
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {}) -- clear contents

    vim.fn.jobstart({ 'npm', 'run', 'build' }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { 'stdout' })
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)

          -- check for typescript errors
          for _, line in ipairs(data) do
            if string.find(line, ': error ') ~= nil then
              vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { '❌' })
              vim.api.nvim_win_set_buf(window, buffer) -- make buffer visible
              return
            end
          end
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { '✅' })
          vim.api.nvim_win_set_buf(window, buffer) -- make buffer visible
        end
      end,
      on_stderr = function(_, data)
        if data and #data >= 1 and string_not_empty(data[1]) then
          print(data[1])
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { 'stderr' })
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
          vim.api.nvim_win_set_buf(window, buffer) -- make buffer visible
        end
      end,
    })
  end,
})

return {}
