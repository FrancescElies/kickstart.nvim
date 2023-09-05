return {
  'FrancescElies/wezterm-mux.nvim',
  config = function()
    local mux = require 'wezterm-mux'
    vim.keymap.set('n', '<C-h>', mux.wezterm_move_left)
    vim.keymap.set('n', '<C-l>', mux.wezterm_move_right)
    vim.keymap.set('n', '<C-j>', mux.wezterm_move_down)
    vim.keymap.set('n', '<C-k>', mux.wezterm_move_up)
    vim.keymap.set('n', '<A-x>', '<C-w>q')
  end,
}
