return {
  'alexalemi/judge.nvim',
  ft = 'janet',
  dependencies = {
    -- Optional: for better Janet syntax highlighting
    'bakpakin/janet.vim',
  },
  config = function()
    require('judge').setup()
  end,
}
