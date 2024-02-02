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

local function find_typescript_for_javascript_file()
  local buffnr = vim.api.nvim_get_current_buf()
  local bufname = vim.fn.bufname(buffnr)
  local lines = vim.api.nvim_buf_get_lines(buffnr, 0, -1, false)
  for _, line in pairs(lines) do
    local map_file = string.match(line, '//# sourceMappingURL=(.+)')
    if map_file ~= nil then
      local bufpath = vim.fn.getcwd()
      local mapping_file_path = vim.fn.resolve(bufpath .. '/' .. map_file)
      local mapping_file = io.open(mapping_file_path)
      if mapping_file == nil then
        return
      end
      print('js file mapping found: ' .. mapping_file_path)
      local mapping_file_contents = mapping_file:read '*a'
      mapping_file:close()
      local ts_file = string.match(mapping_file_contents, '%["(.-%.ts)"%]')
      vim.cmd('e ' .. ts_file)
      vim.cmd ':set filetype=typescript'
      return
    end
  end
end

vim.api.nvim_create_user_command('FindTSForCurrentJSfile', find_typescript_for_javascript_file, {})

-- When opening a javascript file opens it's associated
-- typescript file if a mapping is found
-- Searches for something like
--     //# sourceMappingURL=my.file.js.map
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   group = 'bufcheck',
--   pattern = '*.js',
--   callback = find_typescript_for_javascript_file,
-- })

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

local function attach_to_buffer(pattern, command)
  vim.api.nvim_create_autocmd('BufWritePost', {

    group = vim.api.nvim_create_augroup('AutoRun', { clear = true }),
    pattern = pattern,
    callback = function()
      local src_buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      local buffer = get_buffer_by_name_or_scratch(src_buf_name .. ':autorun')
      local window = vim.api.nvim_get_current_win()
      -- clear contents
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
      local function append(_, data)
        if data then
          vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
        end
        -- vim.api.nvim_win_set_buf(window, buffer) -- make buffer visible
        print 'autorun done'
      end

      vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = append,
        on_stderr = append,
      })
    end,
  })
end

attach_to_buffer('*.ts', { 'npm', 'run', 'build_dev' })

vim.api.nvim_create_user_command('AutoRun', function()
  local command = vim.split(vim.fn.input 'Command:', ' ')
  attach_to_buffer(command)
end, {})

return {}
