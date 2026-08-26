local sensitive = vim.api.nvim_create_augroup('SensitiveBuffers', {
  clear = true,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = sensitive,
  pattern = '*.age',
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
    vim.opt_local.undofile = false
  end,
})

vim.api.nvim_create_user_command('AgeEncrypt', function(opts)
  local output = opts.args ~= '' and vim.fn.expand(opts.args) or vim.fn.expand '%:p' .. '.age'

  local input = vim.fn.tempname()

  -- Write the current buffer to a temporary file
  vim.cmd('silent write! ' .. vim.fn.fnameescape(input))

  -- Open age in an interactive terminal so it can securely prompt.
  vim.cmd 'botright split'
  vim.cmd 'resize 8'

  local command = {
    'age',
    '--passphrase',
    '--output',
    output,
    input,
  }

  vim.fn.termopen(command, {
    on_exit = function(_, code)
      vim.fn.delete(input)
      if code == 0 then
        vim.notify('Encrypted: ' .. output)
      else
        vim.notify('Encryption failed', vim.log.levels.ERROR)
      end
    end,
  })
end, {
  nargs = '?',
  desc = 'Encrypt the current buffer with an age passphrase',
})

vim.api.nvim_create_user_command('AgeDecrypt', function()
  local file = vim.fn.expand '%:p'
  local result = vim
    .system({
      'age',
      '--decrypt',
      '--identity',
      vim.fn.expand '~/.config/age/key.txt',
      file,
    }, {
      text = true,
    })
    :wait()

  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(
    0,
    0,
    -1,
    false,
    vim.split(result.stdout, '\n', {
      plain = true,
    })
  )

  vim.bo.modified = false
end, {
  desc = 'Decrypt the current age file into the buffer',
})
