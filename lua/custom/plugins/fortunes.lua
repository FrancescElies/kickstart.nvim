local augroup = vim.api.nvim_create_augroup('StartupMessages', { clear = true })

-- Create autocommand that runs on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  callback = function()
    vim.schedule(function()
      local info = vim.list_extend({
        'Fortune:',
      }, require('fortune').get_fortune())
      vim.notify(vim.fn.join(info, '\n'))
    end)
  end,
})

return {
  'rubiin/fortune.nvim',
  opts = {
    content_type = 'tips',
  },
}
