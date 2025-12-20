-- stylua: ignore start
-- vim.keymap.set('n', '<leader>vq', function() require('quicker').toggle() end, { desc = '[v]im Toggle [q]uickfix', })
-- vim.keymap.set('n', '<leader>vl', function() require('quicker').toggle { loclist = true } end, { desc = '[v]im Toggle [l]oclist' })
-- stylua: ignore end

-- Toggle quickfix (global)
vim.keymap.set('n', '<leader>qt', function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid > 0 then
    vim.cmd('cclose')
  else
    vim.cmd('botright copen')
  end
end, { silent = true })

-- Toggle loclist (per-window)
vim.keymap.set('n', '<leader>lt', function()
  local loc_winid = vim.fn.getloclist(vim.api.nvim_get_current_win(), { winid = 0 }).winid
  if loc_winid > 0 then
    vim.cmd('lclose')
  else
    vim.cmd('lopen')
  end
end, { silent = true })

local function jump_diagnostic_by_severity(opts)
  local count = opts.count or 1
  local severities = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  }
  for _, severity in ipairs(severities) do
    local diagnostics = vim.diagnostic.get(0, { severity = severity })
    if #diagnostics > 0 then
      -- vim.diagnostic.goto_next { severity = severity }
      vim.diagnostic.jump { count = count, float = true, severity = severity }
      return
    end
  end
end

local function is_loclist_open()
  return vim.fn.getloclist(vim.api.nvim_get_current_win(), { winid = 0 }).winid > 0
end

local function is_quickfix_open()
  return vim.fn.getqflist({ winid = 0 }).winid > 0
end

vim.g.diagnostic_visit_errors_first = true
vim.api.nvim_create_user_command('ToggleDiagnosticVisitOrder', function()
  _G.diagnostic_by_Severity_enabled = not _G.autosave_enabled
  print('DiagnosticBySeverity ' .. (_G.autosave_enabled and 'enabled' or 'disabled'))
end, {})
vim.keymap.set('n', '<leader>vD', ':ToggleDiagnosticVisitOrder<cr>', { desc = '[d]iagnostic visit order' })

local function diagnostic_jump(opts)
  if vim.g.diagnostic_visit_errors_first then
    jump_diagnostic_by_severity { count = opts.count }
  else
    vim.diagnostic.jump { count = opts.count, float = true }
  end
  vim.cmd 'normal! zz'
end

vim.keymap.set('n', '<M-k>', function()
  diagnostic_jump { count = -1 }
end)

vim.keymap.set('n', '<M-j>', function()
  diagnostic_jump { count = 1 }
end)

vim.keymap.set('n', '<c-h>', ':colder<cr>')
vim.keymap.set('n', '<c-l>', ':cnewer<cr>')
vim.keymap.set('n', '<c-j>', function()
  if is_loclist_open() then
    vim.cmd 'lnext' -- next quickfix item
    vim.cmd 'normal! zz'
  elseif is_quickfix_open() then
    vim.cmd 'cnext' -- next quickfix item
    vim.cmd 'normal! zz'
  else
    diagnostic_jump { count = 1 }
  end
end)

vim.keymap.set('n', '<c-k>', function()
  if is_loclist_open() then
    vim.cmd 'lprevious' -- previous quickfix item
    vim.cmd 'normal! zz'
  elseif is_quickfix_open() then
    vim.cmd 'cprevious' -- previous quickfix item
    vim.cmd 'normal! zz'
  else
    if vim.g.diagnostic_visit_errors_first then
      jump_diagnostic_by_severity { count = -1 }
    else
      vim.diagnostic.jump { count = -1, float = true }
    end
  end
end)

vim.keymap.set('n', '<C-j>', function()
  if is_loclist_open() then
    vim.cmd 'lnext' -- next quickfix item
    vim.cmd 'normal! zz'
  elseif is_quickfix_open() then
    vim.cmd 'cnext' -- next quickfix item
    vim.cmd 'normal! zz'
  else
    if vim.g.diagnostic_visit_errors_first then
      jump_diagnostic_by_severity { count = 1 }
    else
      vim.diagnostic.jump { count = 1, float = true }
    end
  end
end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set('n', 'J', ':cnext<CR>zz<C-w>p', opts)
    vim.keymap.set('n', 'K', ':cprev<CR>zz<C-w>p', opts)

    vim.keymap.set('n', '+', function()
      require('quicker').expand { before = 2, after = 2, add_to_existing = true }
    end, opts)

    vim.keymap.set('n', '-', require('quicker').collapse, opts)
  end,
})

return {
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  -- {
  --   'kevinhwang91/nvim-bqf',
  --   enabled = false,
  --   config = function()
  --     require('bqf').setup()
  --   end,
  -- },
  -- {
  --   'stevearc/qf_helper.nvim',
  --   opts = {},
  -- },
}
