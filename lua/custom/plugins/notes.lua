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
      home = vim.fn.expand '~/src/notes',
    }
  end,
  keys = {
    { '<leader>z', '<cmd>Telekasten panel<cr>', desc = '[n]otes' },
    -- Most used functions
    { '<leader>z#', '<cmd> Telekasten show_tags<cr>', desc = 'Show [#] Tags' },
    { '<leader>za', '<cmd> Telekasten show_tags<cr>', desc = 'Show T[a]gs' },
    { '<leader>zb', '<cmd> Telekasten show_backlinks<cr>', desc = 'Show [B]acklinks' },
    -- { '<leader>zc', "<cmd> Telekasten show_calendar<cr>",             desc = 'Show [C]al' },
    -- { '<leader>zC', ':CalendarT<cr>',                                             desc = '[C]alendar' },
    { '<leader>zd', '<cmd> Telekasten find_daily_notes<cr>', desc = 'Find [D]ailies' },
    { '<leader>zf', '<cmd> Telekasten find_notes<cr>', desc = '[F]ind Notes' },
    { '<leader>zF', '<cmd> Telekasten find_friends<cr>', desc = '[F]ind Friends' },
    { '<leader>zg', '<cmd> Telekasten search_notes<cr>', desc = '[G]rep Notes' },
    { '<leader>zi', '<cmd> Telekasten paste_img_and_link<cr>', desc = 'Paste [i]mg & Link' },
    { '<leader>zI', '<cmd> Telekasten insert_img_link({ i=true })<cr>', desc = 'Insert [I]MG link' },
    { '<leader>zl', '<cmd> Telekasten insert_link<cr>', desc = 'Insert [L]ink' },
    { '<leader>zL', '<cmd> Telekasten follow_link<cr>', desc = 'Follow [L]ink' },
    { '<leader>zm', '<cmd> Telekasten browse_media<cr>', desc = 'Browse [M]edia' },
    { '<leader>zn', '<cmd> Telekasten new_note<cr>', desc = 'New [N]ote' },
    { '<leader>zN', '<cmd> Telekasten new_templated_note<cr>', desc = 'New Templated [N]ote' },
    { '<leader>zp', '<cmd> Telekasten preview_img<cr>', desc = '[P]review img' },
    { '<leader>zr', '<cmd> Telekasten rename_note<cr>', desc = '[R]ename Note' },
    { '<leader>zt', '<cmd> Telekasten toggle_todo<cr>', desc = 'Toggle [T]odo' },
    { '<leader>zT', '<cmd> Telekasten goto_today<cr>', desc = 'Goto [T]oday' },
    { '<leader>zw', '<cmd> Telekasten find_weekly_notes<cr>', desc = 'Find [W]eeklies' },
    { '<leader>zW', '<cmd> Telekasten goto_thisweek<cr>', desc = 'Goto [W]eekly' },
    { '<leader>zy', '<cmd> Telekasten yank_notelink<cr>', desc = '[Y]ank Noteline' },
  },
}
