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
        -- lua
        nls.builtins.formatting.stylua,
        -- javascript, typescript
        nls.builtins.formatting.biome,
        -- python
        nls.builtins.formatting.black,
        nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.ruff,
        -- rust
        nls.builtins.formatting.rustfmt,
        -- other
        nls.builtins.formatting.buf,    -- https://github.com/bufbuild/buf
        nls.builtins.diagnostics.typos, -- https://github.com/crate-ci/typos#install
      },
    }
  end,
}
