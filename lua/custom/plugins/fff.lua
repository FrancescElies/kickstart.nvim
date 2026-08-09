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

local fff = require 'fff'

vim.keymap.set('n', 'ff', fff.find_files, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', 'fg', fff.live_grep, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', 'fd', function() fff.find_files_in_dir(vim.fn.expand '%:p:h') end, { desc = '[f]ind files in buffer parent [d]ir'  })
vim.keymap.set('n', 'fr', '<cmd>FFFResume<cr>', { desc = '[f]ind [r]esume' })
vim.keymap.set('n', 'fs', fff.scan_files, { desc = 'scan files' })
vim.keymap.set('n', 'fw', fff.live_grep_under_cursor, { desc = '[f]ind [w]ord / selection' })
vim.keymap.set('n', 'fz', function() fff.live_grep { grep = { modes = { 'fuzzy', 'plain' } } } end, { desc = '[f]ind fu[zz]y' })
