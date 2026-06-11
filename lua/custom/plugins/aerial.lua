vim.pack.add { 'https://github.com/stevearc/aerial.nvim' }
vim.keymap.set('n', '<leader>ae', '<cmd>AerialToggle! left<CR>', { desc = '[ae]rial' })

require('aerial').setup {
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', function()
      if require('aerial').is_open() then
        vim.cmd [[AerialPrev]]
      else
        vim.cmd [[normal! {{]]
      end
    end, { buffer = bufnr })
    vim.keymap.set('n', '}', function()
      if require('aerial').is_open() then
        vim.cmd [[AerialNext]]
      else
        vim.cmd [[normal! }}]]
      end
    end, { buffer = bufnr })
  end,
}
