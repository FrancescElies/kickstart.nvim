return {
  'monaqa/dial.nvim',
  -- lazy-load on keys
  -- mode is `n` by default. For more advanced options, check the section on key mappings
  keys = {
    {
      'n',
      '<C-a>',
      function()
        require('dial.map').manipulate('increment', 'normal')
      end,
    },
    {
      'n',
      '<C-x>',
      function()
        require('dial.map').manipulate('decrement', 'normal')
      end,
    },
    {
      'n',
      'g<C-a>',
      function()
        require('dial.map').manipulate('increment', 'gnormal')
      end,
    },
    {
      'n',
      'g<C-x>',
      function()
        require('dial.map').manipulate('decrement', 'gnormal')
      end,
    },
    {
      'x',
      '<C-a>',
      function()
        require('dial.map').manipulate('increment', 'visual')
      end,
    },
    {
      'x',
      '<C-x>',
      function()
        require('dial.map').manipulate('decrement', 'visual')
      end,
    },
    {
      'x',
      'g<C-a>',
      function()
        require('dial.map').manipulate('increment', 'gvisual')
      end,
    },
    {
      'x',
      'g<C-x>',
      function()
        require('dial.map').manipulate('decrement', 'gvisual')
      end,
    },
  },
}
