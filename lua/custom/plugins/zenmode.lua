vim.keymap.set('n', '<leader>z', function()
  require('zen-mode').setup {
    window = { width = 120, options = {} },
  }
  require('zen-mode').toggle()
  vim.wo.wrap = true
  vim.wo.number = true
  vim.wo.rnu = true
end)

return {
  'folke/zen-mode.nvim',
}
