-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
return {
  'jose-elias-alvarez/null-ls.nvim',
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
        nls.builtins.formatting.rome,
        -- nls.builtins.formatting.spell,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.black,
        nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.ruff,
        -- nls.builtins.diagnostics.flake8,
      },
    }
  end,
}
