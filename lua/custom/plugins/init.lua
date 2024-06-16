-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

vim.lsp.inlay_hint.enable(true)

-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

return {
  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', dependencies = { 'moll/vim-bbye' } },
}
