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

vim.keymap.set('n', 'sf', function() require('fff').find_files() end, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', 'sg', function() require('fff').live_grep() end, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', 'sw', function() require('fff').live_grep_under_cursor() end, { desc = '[s]earch [w]ord / selection' })
vim.keymap.set('n', 'sz', function() require('fff').live_grep { grep = { modes = { 'fuzzy', 'plain' } } } end, { desc = '[s]earch fu[zz]y' })
