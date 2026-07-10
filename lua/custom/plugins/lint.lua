-- Linting
local fn = require 'custom.fn'

vim.pack.add { fn.gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'

-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
lint.linters_by_ft = lint.linters_by_ft or {}
lint.linters_by_ft['clojure'] = nil
lint.linters_by_ft['dockerfile'] = nil
lint.linters_by_ft['inko'] = nil
lint.linters_by_ft['janet'] = nil
lint.linters_by_ft['json'] = nil
lint.linters_by_ft['markdown'] = { 'vale' }
lint.linters_by_ft['python'] = { 'ruff' }
-- lint.linters_by_ft['rust'] = nil -- bacon-ls will do
lint.linters_by_ft['rust'] = { 'clippy' }
lint.linters_by_ft['rst'] = nil
lint.linters_by_ft['ruby'] = nil
lint.linters_by_ft['terraform'] = nil
lint.linters_by_ft['text'] = nil

-- Carry out the actual linting on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
