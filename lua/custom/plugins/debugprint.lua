local fn = require 'custom.fn'

vim.pack.add { fn.gh 'andrewferrier/debugprint.nvim' }
require('debugprint').setup {
  keymaps = {
    -- `yd` mnemonic: [y]ou [d]ebug
    normal = {
      plain_below = 'ydp',
      plain_above = 'ydP',
      variable_below = 'ydv',
      variable_above = 'ydV',
      variable_below_alwaysprompt = '',
      variable_above_alwaysprompt = '',
      surround_plain = 'ydsp',
      surround_variable = 'ydsv',
      surround_variable_alwaysprompt = '',
      textobj_below = 'ydo',
      textobj_above = 'ydO',
      textobj_surround = 'ydso',
      toggle_comment_debug_prints = 'ydt',
      delete_debug_prints = 'ydd',
    },
    insert = {
      -- plain = '<C-G>p',
      -- variable = '<C-G>v',
    },
    visual = {
      variable_below = 'ydv',
      variable_above = 'ydV',
    },
  },
}
