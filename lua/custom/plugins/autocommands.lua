vim.api.nvim_create_augroup('bufcheck', { clear = true })
vim.api.nvim_create_augroup('markdown', { clear = true })

--
--
-- Buffer (which opened a file)
--
--

-- auto create intermediate directories on save
vim.api.nvim_create_autocmd({ 'FileWritePre', 'BufWritePre' }, {
  group = 'bufcheck',
  pattern = '*',
  callback = function()
    vim.fn.mkdir(
      vim.fn.expand '%:p:h', -- current-buffer:path:head(directory)
      'p' -- create intermediate directories
    )
  end,
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

vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'markdown',
  pattern = '*.md',
  -- command = 'setlocal wrap | setlocal spell',
  callback = function(_)
    vim.diagnostic.enable(false, { bufnr = 0 })
    vim.wo.wrap = true
    vim.wo.spell = true
  end,
})
--
-- Autosave Markdown files
vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
  group = 'markdown',
  pattern = '*.md',
  callback = function()
    if vim.bo.modified then
      vim.cmd 'silent write'
    end
  end,
})

-- Autosave when leaving window
vim.api.nvim_create_autocmd({
  'VimLeavePre',
  'FocusLost',
}, {
  pattern = '*',
  callback = function()
    vim.cmd 'silent! wall'
  end,
})

local function find_typescript_for_javascript_file()
  local buffnr = vim.api.nvim_get_current_buf()
  -- local bufname = vim.fn.bufname(buffnr)
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

local function get_buffer_by_name_or_scratch(name, clean)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.fn.bufname(bufnr)
    if buf_name == name then
      if clean then
        vim.api.nvim_buf_set_lines(bufnr, -0, -1, false, {})
      end
      -- buffer found
      return bufnr
    end
  end

  -- buffer not found
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buffer, name)
  return buffer
end

--
--
-- Autorun
--
--

local function attach_to_buffer(bufnr, pattern, command)
  vim.api.nvim_create_autocmd('BufWritePost', {

    group = vim.api.nvim_create_augroup('MyAutoRun', { clear = true }),
    pattern = pattern,
    callback = function()
      local window = vim.api.nvim_get_current_win()
      -- clear contents
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
      local function append(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end

      vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = append,
        on_stderr = append,
      })
    end,
  })
end

-- attach_to_buffer('*.ts', { 'npm', 'run', 'build_dev' })

vim.api.nvim_create_user_command('AutoRun', function()
  local pattern = vim.fn.input('Pattern:', '*.rs')
  local command = vim.fn.input 'Command:'

  -- create new split
  vim.cmd.new()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  local bufnr = get_buffer_by_name_or_scratch('autorun for ' .. pattern .. ': ' .. command)
  vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)

  attach_to_buffer(bufnr, vim.split(pattern, ' '), vim.split(command, ' '))
end, {})

vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

-- WARN: can't setqflist in callback
-- vim.api.nvim_create_user_command('QuickfixCmd', function(opts)
--   vim.system(vim.fn.split(opts.args), { text = true }, function(obj)
--     vim.fn.setqflist(vim.fn.split(obj.stdout))
--     vim.cmd 'copen'
--   end)
-- end, { nargs = 1 })

return {}
