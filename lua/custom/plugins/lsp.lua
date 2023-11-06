-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md

vim.api.nvim_create_user_command('FormatDiagnostic', function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.diagnostic.is_disabled(buf) then
    vim.diagnostic.enable(vim.api.nvim_get_current_buf())
    print('Enabling diagnostic for buffer: ' .. vim.api.nvim_buf_get_name(buf))
  else
    vim.diagnostic.disable()
    print('Disabling diagnostic for buffer: ' .. vim.api.nvim_buf_get_name(buf))
  end
end, {})

return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'mason.nvim' },
  opts = function()
    local nls = require 'null-ls'
    return {
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
      sources = {
        nls.builtins.formatting.fish_indent,
        nls.builtins.diagnostics.fish,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.biome,
        -- nls.builtins.formatting.spell,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.buf,
        nls.builtins.formatting.black,
        nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.ruff,
        nls.builtins.diagnostics.ltrs,
        nls.builtins.formatting.rustfmt,
        nls.builtins.diagnostics.typos,
        -- nls.builtins.diagnostics.flake8,
      },
    }
  end,
}
