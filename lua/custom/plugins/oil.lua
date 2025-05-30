-- Show CWD in the winbar
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    win_options = {
      winbar = '%!v:lua.get_oil_winbar()',
    },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-k>'] = false,
      ['<C-j>'] = false,
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-S-s>'] = { 'actions.select', opts = { horizontal = true } },
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
          else
            require('oil').set_columns { 'icon' }
          end
        end,
      },
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'open parent dir' },
    { '<leader>fd', ':Oil --float<cr>', desc = '[f]ile open parent [d]dir' },
  },
}
