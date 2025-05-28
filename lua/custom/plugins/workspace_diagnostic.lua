vim.api.nvim_set_keymap('n', '<leader>x', '', {
  noremap = true,
  desc = 'worksapce diagnostics',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
      require('workspace-diagnostics').populate_workspace_diagnostics(client, 0)
    end
  end,
})

return {
  'artemave/workspace-diagnostics.nvim',
}
