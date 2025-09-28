local lisp_file_types = { 'clojure', 'fennel', 'janet' }
return {
  { 'guns/vim-sexp', ft = lisp_file_types },
  { 'janet-lang/janet.vim', ft = { 'janet' } },
  { 'eraserhd/parinfer-rust', build = 'cargo build --release', ft = lisp_file_types },
  -- {
  --   'Olical/conjure',
  --   ft = vim.tbl_extend('keep', { 'python' }),
  --   lazy = true,
  --   init = function()
  --     -- Set configuration options here
  --     -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
  --     -- This is VERY helpful when reporting an issue with the project
  --     -- vim.g["conjure#debug"] = true
  --   end,
  --
  --   -- Optional cmp-conjure integration
  --   dependencies = { 'PaterJason/cmp-conjure' },
  -- },
  -- {
  --   'PaterJason/cmp-conjure',
  --   lazy = true,
  --   config = function()
  --     local cmp = require 'cmp'
  --     local config = cmp.get_config()
  --     table.insert(config.sources, { name = 'conjure' })
  --     return cmp.setup(config)
  --   end,
  -- },
}
