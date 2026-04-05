--
-- diagnostic
--

vim.keymap.set('n', '<leader>vdt', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = '[v]im [D]iagnostic toggle' })

--- @param opts { level: vim.diagnostic.Severity }
local function set_diagnostic_config(opts)
  vim.diagnostic.config {
    severity_sort = true,
    signs = { severity = { min = opts.level } },
    underline = { severity = { min = opts.level } },
    -- virtual_lines = { severity = { min = opts.level } },
    virtual_text = { severity = { min = opts.level } },
  }
end

vim.keymap.set('n', '<leader>vda', function()
  set_diagnostic_config { level = vim.diagnostic.severity.HINT }
end, { desc = '[v]im [d]iag. show [a]ll' })
vim.keymap.set('n', '<leader>vdw', function()
  set_diagnostic_config { level = vim.diagnostic.severity.WARN }
end, { desc = '[v]im [d]iag. show [w]arn' })
vim.keymap.set('n', '<leader>vde', function()
  set_diagnostic_config { level = vim.diagnostic.severity.ERROR }
end, { desc = '[v]im [d]iag. show [e]rror' })

-- default
set_diagnostic_config { level = vim.diagnostic.severity.ERROR }

return {}
