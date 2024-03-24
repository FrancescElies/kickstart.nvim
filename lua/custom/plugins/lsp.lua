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

--https://github.com/LazyVim/LazyVim/blob/91126b9896bebcea9a21bce43be4e613e7607164/lua/lazyvim/util/toggle.lua#L64
local function inlay_hints(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == 'function' then
    ih(buf, value)
  elseif type(ih) == 'table' and ih.enable then
    if value == nil then
      value = not ih.is_enabled(buf)
    end
    ih.enable(buf, value)
  end
end
local function refresh_inlay_hints()
  inlay_hints(0, true)
end

-- https://vinnymeller.com/posts/neovim_nightly_inlay_hints/
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      inlay_hints(args.buf, true)
    end
    -- whatever other lsp config you want
  end,
})

vim.keymap.set('n', '<leader>vi', inlay_hints, { desc = 'Vim toggle Inlay hints' })
vim.keymap.set('n', '<leader>vI', refresh_inlay_hints, { desc = 'Vim refresh Inlay hints' })

return {}
