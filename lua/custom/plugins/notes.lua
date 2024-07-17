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
    { '<leader>n', '<cmd>Telekasten panel<cr>', desc = '[n]otes' },
    -- Most used functions
    { '<leader>n#', '<cmd> Telekasten show_tags<cr>', desc = 'Show [#] Tags' },
    { '<leader>na', '<cmd> Telekasten show_tags<cr>', desc = 'Show T[a]gs' },
    { '<leader>nb', '<cmd> Telekasten show_backlinks<cr>', desc = 'Show [B]acklinks' },
    -- { '<leader>nc', "<cmd> Telekasten show_calendar<cr>",             desc = 'Show [C]al' },
    -- { '<leader>nC', ':CalendarT<cr>',                                             desc = '[C]alendar' },
    { '<leader>nd', '<cmd> Telekasten find_daily_notes<cr>', desc = 'Find [D]ailies' },
    { '<leader>nf', '<cmd> Telekasten find_notes<cr>', desc = '[F]ind Notes' },
    { '<leader>nF', '<cmd> Telekasten find_friends<cr>', desc = '[F]ind Friends' },
    { '<leader>ng', '<cmd> Telekasten search_notes<cr>', desc = '[G]rep Notes' },
    { '<leader>ni', '<cmd> Telekasten paste_img_and_link<cr>', desc = 'Paste [i]mg & Link' },
    { '<leader>nI', '<cmd> Telekasten insert_img_link({ i=true })<cr>', desc = 'Insert [I]MG link' },
    { '<leader>nl', '<cmd> Telekasten insert_link<cr>', desc = 'Insert [L]ink' },
    { '<leader>nL', '<cmd> Telekasten follow_link<cr>', desc = 'Follow [L]ink' },
    { '<leader>nm', '<cmd> Telekasten browse_media<cr>', desc = 'Browse [M]edia' },
    { '<leader>nn', '<cmd> Telekasten new_note<cr>', desc = 'New [N]ote' },
    { '<leader>nN', '<cmd> Telekasten new_templated_note<cr>', desc = 'New Templated [N]ote' },
    { '<leader>np', '<cmd> Telekasten preview_img<cr>', desc = '[P]review img' },
    { '<leader>nr', '<cmd> Telekasten rename_note<cr>', desc = '[R]ename Note' },
    { '<leader>nt', '<cmd> Telekasten toggle_todo<cr>', desc = 'Toggle [T]odo' },
    { '<leader>nT', '<cmd> Telekasten goto_today<cr>', desc = 'Goto [T]oday' },
    { '<leader>nw', '<cmd> Telekasten find_weekly_notes<cr>', desc = 'Find [W]eeklies' },
    { '<leader>nW', '<cmd> Telekasten goto_thisweek<cr>', desc = 'Goto [W]eekly' },
    { '<leader>ny', '<cmd> Telekasten yank_notelink<cr>', desc = '[Y]ank Noteline' },
  },
}
