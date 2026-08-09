local fn = require 'custom.fn'
vim.pack.add {
  fn.gh 'stevearc/quicker.nvim',
}
local quicker = require 'quicker'
quicker.setup {}

vim.keymap.set('n', '<localleader>l', function() quicker.toggle { loclist = true } end, { desc = '[l]oclist' })

vim.keymap.set('n', '<leader>q', quicker.toggle, { desc = '[q]uickfix' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[e]rror show' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setqflist, { desc = '[d]iagnostics' })

local function quickfix_severity(severity)
  return function()
    vim.diagnostic.setqflist { severity = severity }
    vim.diagnostic.setloclist { severity = severity }
  end
end

vim.api.nvim_create_user_command('QuickLevelError', function() quickfix_severity(vim.diagnostic.severity.ERROR) end, {})
vim.api.nvim_create_user_command('QuickLevelWarning', function() quickfix_severity(vim.diagnostic.severity.WARN) end, {})

local function jump_diagnostic_by_severity(opts)
  local count = opts.count or 1
  local float = opts.float or 1
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
      vim.diagnostic.jump { count = count, float = float, severity = severity }
      return
    end
  end
end

local function is_quickfix_open() return vim.fn.getqflist({ winid = 0 }).winid > 0 end
local function is_loclist_open() return vim.fn.getloclist(vim.api.nvim_get_current_win(), { winid = 0 }).winid > 0 end

vim.g.diagnostic_visit_errors_first = true
vim.api.nvim_create_user_command('ToggleDiagnosticVisitOrder', function()
  vim.g.diagnostic_visit_errors_first = not vim.g.diagnostic_visit_errors_first
  print('DiagnosticBySeverity ' .. (vim.g.diagnostic_visit_errors_first and 'enabled' or 'disabled'))
end, {})
vim.keymap.set('n', '<leader>td', '<cmd>ToggleDiagnosticVisitOrder<cr>', { desc = '[t]oggle [d]iagnostic visit order' })

local function diagnostic_jump(opts)
  if vim.g.diagnostic_visit_errors_first then
    jump_diagnostic_by_severity { count = opts.count, float = true }
  else
    vim.diagnostic.jump { count = opts.count, float = true }
  end
end

vim.keymap.set('n', '<M-k>', function()
  if is_quickfix_open() then
    vim.cmd 'cprevious'
  else
    diagnostic_jump { count = -1, float = true }
  end
  vim.cmd 'normal! zz'
end, { desc = 'previous quickfix item' })

vim.keymap.set('n', '<M-j>', function()
  if is_quickfix_open() then
    vim.cmd 'cnext'
  else
    diagnostic_jump { count = 1, float = true }
  end
  vim.cmd 'normal! zz'
end, { desc = 'quickfix next' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set('n', 'J', '<cmd>cnext<CR>zz<C-w>p', opts)
    vim.keymap.set('n', 'K', '<cmd>cprev<CR>zz<C-w>p', opts)
  end,
})
