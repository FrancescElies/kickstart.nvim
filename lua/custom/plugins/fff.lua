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

vim.keymap.set('n', 'ff', function() require('fff').find_files() end, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', 'fg', function() require('fff').live_grep() end, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', 'fw', function() require('fff').live_grep_under_cursor() end, { desc = '[f]ind [w]ord / selection' })
vim.keymap.set('n', 'fz', function() require('fff').live_grep { grep = { modes = { 'fuzzy', 'plain' } } } end, { desc = '[f]ind fu[zz]y' })
