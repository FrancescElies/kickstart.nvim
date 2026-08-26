local fn = require 'custom.fn'
vim.keymap.set('n', '<localleader><localleader>', function()
  vim.cmd 'wall'
  fn.run_async { 'npm', 'run', 'build' }
end, { buffer = 0, desc = 'npm run build' })
