return {
  'stevearc/aerial.nvim',
  keys = {
    { '<leader>a', '<cmd>AerialToggle!<CR>', 'aerial' , desc= 'aerial'},
  },
  opts = {
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
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
