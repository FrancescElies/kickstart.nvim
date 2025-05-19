return {
  'Canop/nvim-bacon',
  config = function()
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
      pattern = { '*.rs', '*.toml' },
      group = vim.api.nvim_create_augroup('my-rust-bacon', { clear = true }),
      callback = function(event)
        local nkeymap = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'bacon: ' .. desc })
        end
        nkeymap('!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', 'next bacon issue')
        nkeymap(',', ':BaconList<CR>', 'bacon list')
      end,
    })
  end,
}
