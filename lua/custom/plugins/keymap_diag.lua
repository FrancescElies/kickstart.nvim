--
-- diagnostic
--

vim.keymap.set({ 'n', 'v' }, '<leader>qx', vim.lsp.buf.references, { buffer = true, desc = 'references to quickfix' })
vim.keymap.set({ 'n', 'v' }, 'yr', vim.lsp.buf.references, { buffer = true, desc = 'you references to quickfix' })

vim.keymap.set('n', '<leader>qb', vim.diagnostic.setloclist, { desc = '[q]uickfix [b]uffer diag.' })
vim.keymap.set('n', '<leader>qa', vim.diagnostic.setqflist, { desc = '[q]uickfix all [d]iag.' })
vim.keymap.set('n', '<leader>qw', function() vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN } end, { desc = '[q]uickfix diag. [w]arnings' })
vim.keymap.set('n', '<leader>qe', function() vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR } end, { desc = '[q]uickfix diag. [e]rrors' })

vim.keymap.set('n', '<leader>vdt', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = '[v]im [D]iagnostic toggle' })

--- @param opts { level: vim.diagnostic.Severity }
local function set_diagnostic_config(opts)
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = { float = true },
    underline = { severity = { min = opts.level } },
    signs = vim.g.have_nerd_font and {
      severity = { min = opts.level },
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    -- virtual_lines = { severity = { min = opts.level } },
    virtual_text = {
      severity = { min = opts.level },
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }
end

vim.keymap.set('n', '<leader>vda', function() set_diagnostic_config { level = vim.diagnostic.severity.HINT } end, { desc = '[v]im [d]iag. show [a]ll' })
vim.keymap.set('n', '<leader>vdw', function() set_diagnostic_config { level = vim.diagnostic.severity.WARN } end, { desc = '[v]im [d]iag. show [w]arn' })
vim.keymap.set('n', '<leader>vde', function() set_diagnostic_config { level = vim.diagnostic.severity.ERROR } end, { desc = '[v]im [d]iag. show [e]rror' })

return {}
