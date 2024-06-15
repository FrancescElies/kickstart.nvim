-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true

vim.keymap.set('n', '<leader>m', require('telescope.builtin').marks, { desc = '[m]arks' })

-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

return {
  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', dependencies = { 'moll/vim-bbye' } },

  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
