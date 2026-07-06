vim.pack.add { 'https://github.com/dmtrKovalenko/fff.nvim' }

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd 'fff.nvim' end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = false, show_scores = true },
}

vim.keymap.set('n', 'ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', 'fg', function() require('fff').live_grep() end, { desc = 'LiFFFe grep files' })
vim.keymap.set('n', 'fw', function() require('fff').live_grep_under_cursor() end, { desc = 'FFFind current word / selection' })
vim.keymap.set('n', 'fR', function()
  local dir = vim.fn.expand '%:p:h'
  require('fff').change_indexing_directory(dir)
  vim.notify('fff uses now ' .. dir)
end, { desc = 'FFFind change root' })
vim.keymap.set('n', 'fs', function() require('fff').scan_files() end, { desc = 'FFFind rescan' })
