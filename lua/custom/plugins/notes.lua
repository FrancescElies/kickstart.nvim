local home = os.getenv 'HOME'
if home == nil or home == '' then
  error 'telekasten needs HOME environment variable'
end

return {
  'renerocksai/telekasten.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    -- 'renerocksai/calendar-vim'
  },
  config = function()
    require('telekasten').setup {
      home = vim.fn.expand '~/src/zettelkasten',
    }
  end,
  keys = {
    { '<leader>z', '<cmd>Telekasten panel<CR>', desc = '+Zettelkasten' },
    -- Most used functions
    { '<leader>#', ":lua require('telekasten').show_tags()<CR>", desc = 'Show [#] Tags' },
    { '<leader>za', ":lua require('telekasten').show_tags()<CR>", desc = 'Show T[a]gs' },
    { '<leader>zb', ":lua require('telekasten').show_backlinks()<CR>", desc = 'Show [B]acklinks' },
    -- { '<leader>zc', ":lua require('telekasten').show_calendar()<CR>",             desc = 'Show [C]al' },
    -- { '<leader>zC', ':CalendarT<CR>',                                             desc = '[C]alendar' },
    { '<leader>zd', ":lua require('telekasten').find_daily_notes()<CR>", desc = 'Find [D]ailies' },
    { '<leader>zf', ":lua require('telekasten').find_notes()<CR>", desc = '[F]ind Notes' },
    { '<leader>zF', ":lua require('telekasten').find_friends()<CR>", desc = '[F]ind Friends' },
    { '<leader>zg', ":lua require('telekasten').search_notes()<CR>", desc = '[G]rep Notes' },
    { '<leader>zi', ":lua require('telekasten').paste_img_and_link()<CR>", desc = 'Paste [i]mg & Link' },
    { '<leader>zI', ":lua require('telekasten').insert_img_link({ i=true })<CR>", desc = 'Insert [I]MG link' },
    { '<leader>zl', '<cmd>Telekasten insert_link<CR>', desc = 'Insert [L]ink' },
    { '<leader>zL', ":lua require('telekasten').follow_link()<CR>", desc = 'Follow [L]ink' },
    { '<leader>zm', ":lua require('telekasten').browse_media()<CR>", desc = 'Browse [M]edia' },
    { '<leader>zn', ":lua require('telekasten').new_note()<CR>", desc = 'New [N]ote' },
    { '<leader>zN', ":lua require('telekasten').new_templated_note()<CR>", desc = 'New Templated [N]ote' },
    { '<leader>zp', ":lua require('telekasten').preview_img()<CR>", desc = '[P]review img' },
    { '<leader>zr', ":lua require('telekasten').rename_note()<CR>", desc = '[R]ename Note' },
    { '<leader>zt', ":lua require('telekasten').toggle_todo()<CR>", desc = 'Toggle [T]odo' },
    { '<leader>zT', ":lua require('telekasten').goto_today()<CR>", desc = 'Goto [T]oday' },
    { '<leader>zw', ":lua require('telekasten').find_weekly_notes()<CR>", desc = 'Find [W]eeklies' },
    { '<leader>zW', ":lua require('telekasten').goto_thisweek()<CR>", desc = 'Goto [W]eekly' },
    { '<leader>zy', ":lua require('telekasten').yank_notelink()<CR>", desc = '[Y]ank Noteline' },
  },
}
