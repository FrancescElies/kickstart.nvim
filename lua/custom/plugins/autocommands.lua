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
return {}
