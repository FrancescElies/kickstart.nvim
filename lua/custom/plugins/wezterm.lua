return {
  'mrjones2014/smart-splits.nvim',
  config = function()
    require('smart-splits').setup {
      at_edge = 'stop',
    }
  end,
  keys = {
    {
      '<A-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
      desc = '[n]otes',
    },
    {
      '<A-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
      desc = '[n]otes',
    },
    {
      '<A-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
      desc = '[n]otes',
    },
    {
      '<A-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
      desc = '[n]otes',
    },
    { '<A-x>', '<C-w>q', desc = '[n]otes' },
  },
}
